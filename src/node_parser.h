// FILE: src/node_parser.h
// PURPOSE: High-Speed YYJSON AST Parser (Maps Dart JSON payload to C++ CoreDocument).
// Zero-reallocation vector pre-sizing, cross-platform debug logging & full AST sync.

#pragma once
#include <string>
#include <vector>
#include <cstdint>
#include <cstring>
#include <optional>

#ifndef NDEBUG
#ifdef __ANDROID__
#include <android/log.h>
#define CANVAS_PARSER_LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "CANVAS_ENGINE", __VA_ARGS__)
#else
#include <cstdio>
#define CANVAS_PARSER_LOGE(...) do { fprintf(stderr, "[CoreCanvasEngine] " __VA_ARGS__); fprintf(stderr, "\n"); } while(0)
#endif
#else
#define CANVAS_PARSER_LOGE(...) ((void)0)
#endif

#include "config.h"
#include "yyjson.h"

namespace CoreCanvas {

    class NodeParser {
    public:
        static std::optional<CoreDocument> parse(const char* json_string) {
            if (!json_string) return std::nullopt;

            yyjson_doc *doc = yyjson_read(json_string, std::strlen(json_string), 0);
            if (!doc) {
                CANVAS_PARSER_LOGE("YYJSON failed to parse document payload.");
                return std::nullopt;
            }

            yyjson_val *root = yyjson_doc_get_root(doc);
            CoreDocument coreDoc;

            // 1. Parse CanvasConfig
            yyjson_val *configVal = yyjson_obj_get(root, "config");
            if (configVal && yyjson_is_obj(configVal)) {
                yyjson_val* v;
                if ((v = yyjson_obj_get(configVal, "w"))) coreDoc.config.w = yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "h"))) coreDoc.config.h = yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "format"))) coreDoc.config.targetFormat = (int)yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "dir"))) coreDoc.config.dir = (int)yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "scale"))) coreDoc.config.scale = yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "dpi"))) coreDoc.config.dpi = (int)yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "colorSpace"))) coreDoc.config.colorSpace = (int)yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "quality"))) coreDoc.config.quality = (int)yyjson_get_num(v);
                if ((v = yyjson_obj_get(configVal, "lossless"))) coreDoc.config.lossless = yyjson_get_bool(v);

                if ((v = yyjson_obj_get(configVal, "margin"))) {
                    coreDoc.config.margin = parseEdgeInsets(v);
                }
            }

            // 2. Parse DocumentInfo & ViewerPreferences
            yyjson_val *infoVal = yyjson_obj_get(root, "info");
            if (infoVal && yyjson_is_obj(infoVal)) {
                coreDoc.info = parseDocumentInfo(infoVal);
            }

            // 3. Parse Custom Fonts Map
            yyjson_val *fontsVal = yyjson_obj_get(root, "fonts");
            if (fontsVal && yyjson_is_obj(fontsVal)) {
                yyjson_val *key, *val;
                yyjson_obj_iter iter;
                yyjson_obj_iter_init(fontsVal, &iter);
                while ((key = yyjson_obj_iter_next(&iter))) {
                    val = yyjson_obj_iter_get_val(key);
                    if (yyjson_is_str(key) && yyjson_is_str(val)) {
                        coreDoc.fonts[yyjson_get_str(key)] = yyjson_get_str(val);
                    }
                }
            }

            // 4. Parse Default Document Typography
            yyjson_val *defaultTypoVal = yyjson_obj_get(root, "defaultTypo");
            if (defaultTypoVal && yyjson_is_obj(defaultTypoVal)) {
                coreDoc.defaultTypography = parseTypography(defaultTypoVal);
            }

            // 5. Parse Header, Body, and Footer Trees
            yyjson_val *headerVal = yyjson_obj_get(root, "header");
            if (headerVal) coreDoc.header = parseContainer(headerVal);

            yyjson_val *bodyVal = yyjson_obj_get(root, "body");
            if (bodyVal) coreDoc.body = parseContainer(bodyVal);

            yyjson_val *footerVal = yyjson_obj_get(root, "footer");
            if (footerVal) coreDoc.footer = parseContainer(footerVal);

            yyjson_doc_free(doc);
            return coreDoc;
        }

    private:
        static DocumentInfo parseDocumentInfo(yyjson_val* val) {
            DocumentInfo info;
            if (!val || !yyjson_is_obj(val)) return info;
            yyjson_val* v;
            if ((v = yyjson_obj_get(val, "title")) && yyjson_is_str(v)) info.title = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "author")) && yyjson_is_str(v)) info.author = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "subject")) && yyjson_is_str(v)) info.subject = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "keywords")) && yyjson_is_str(v)) info.keywords = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "creator")) && yyjson_is_str(v)) info.creator = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "producer")) && yyjson_is_str(v)) info.producer = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "creationDate")) && yyjson_is_str(v)) info.creationDate = yyjson_get_str(v);

            if ((v = yyjson_obj_get(val, "viewerPrefs")) && yyjson_is_obj(v)) {
                ViewerPreferences prefs;
                yyjson_val* pv;
                if ((pv = yyjson_obj_get(v, "hideToolbar"))) prefs.hideToolbar = yyjson_get_bool(pv);
                if ((pv = yyjson_obj_get(v, "hideMenubar"))) prefs.hideMenubar = yyjson_get_bool(pv);
                if ((pv = yyjson_obj_get(v, "fitWindow"))) prefs.fitWindow = yyjson_get_bool(pv);
                if ((pv = yyjson_obj_get(v, "pageMode"))) prefs.pageMode = (int)yyjson_get_num(pv);
                if ((pv = yyjson_obj_get(v, "pageLayout"))) prefs.pageLayout = (int)yyjson_get_num(pv);
                info.viewerPrefs = prefs;
            }
            return info;
        }

        static std::optional<BoxConstraints> parseConstraints(yyjson_val* val) {
            if (!val || !yyjson_is_obj(val)) return std::nullopt;
            BoxConstraints c;
            yyjson_val* v;
            if ((v = yyjson_obj_get(val, "w"))) c.width = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "h"))) c.height = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "wPct"))) c.widthPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "hPct"))) c.heightPercent = yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "minW"))) c.minWidth = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "maxW"))) c.maxWidth = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "minH"))) c.minHeight = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "maxH"))) c.maxHeight = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "ratio"))) c.aspectRatio = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "minWPct"))) c.minWidthPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "maxWPct"))) c.maxWidthPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "minHPct"))) c.minHeightPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "maxHPct"))) c.maxHeightPercent = yyjson_get_num(v);

            return c;
        }

        static std::optional<Position> parsePosition(yyjson_val* val) {
            if (!val || !yyjson_is_obj(val)) return std::nullopt;
            Position p; yyjson_val* v;
            if ((v = yyjson_obj_get(val, "type"))) p.type = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "zIndex"))) p.zIndex = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "top"))) p.top = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "left"))) p.left = yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "right"))) p.right = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "bottom"))) p.bottom = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "topPct"))) p.topPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "rightPct"))) p.rightPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "bottomPct"))) p.bottomPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "leftPct"))) p.leftPercent = yyjson_get_num(v);

            return p;
        }

        static std::optional<EdgeInsets> parseEdgeInsets(yyjson_val* val) {
            if (!val || !yyjson_is_arr(val) || yyjson_arr_size(val) < 4) return std::nullopt;
            return EdgeInsets{
                    yyjson_get_num(yyjson_arr_get(val, 0)),
                    yyjson_get_num(yyjson_arr_get(val, 1)),
                    yyjson_get_num(yyjson_arr_get(val, 2)),
                    yyjson_get_num(yyjson_arr_get(val, 3))
            };
        }

        static FlexLayout parseLayout(yyjson_val* val) {
            FlexLayout flex; if (!val || !yyjson_is_obj(val)) return flex; yyjson_val* v;

            if ((v = yyjson_obj_get(val, "display"))) flex.display = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "dir"))) flex.direction = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "justify"))) flex.justifyContent = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "align"))) flex.alignItems = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "wrap"))) flex.wrap = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "layoutDir"))) flex.layoutDirection = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "alignContent"))) flex.alignContent = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "alignSelf"))) flex.alignSelf = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "overflow"))) flex.overflow = (int)yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "gap"))) flex.gap = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "rowGap"))) flex.rowGap = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "colGap"))) flex.columnGap = yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "flexGrow"))) flex.flexGrow = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "flexShrink"))) flex.flexShrink = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "flexBasis"))) flex.flexBasis = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "flexBasisPct"))) flex.flexBasisPercent = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "flexBasisAuto"))) flex.isFlexBasisAuto = yyjson_get_bool(v);

            return flex;
        }

        static Typography parseTypography(yyjson_val* val) {
            Typography typo; if (!val || !yyjson_is_obj(val)) return typo; yyjson_val* v;
            if ((v = yyjson_obj_get(val, "font")) && yyjson_is_str(v)) typo.fontFamily = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "size"))) typo.fontSize = yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "color"))) typo.color = (uint32_t)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "weight"))) typo.weight = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "align"))) typo.align = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "style"))) typo.style = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "decoration"))) typo.decoration = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "overflow"))) typo.textOverflow = (int)yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "fontVariant")) && yyjson_is_str(v)) typo.fontVariant = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "textMode")) && yyjson_is_str(v)) typo.textRenderMode = yyjson_get_str(v);

            if ((v = yyjson_obj_get(val, "lineHeight"))) typo.lineHeight = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "spacing"))) typo.letterSpacing = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "wordSpacing"))) typo.wordSpacing = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "baselineOffset"))) typo.baselineOffset = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "maxLines"))) typo.maxLines = (int)yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "runs")) && yyjson_is_arr(v)) {
                std::vector<TextRun> runsList;
                runsList.reserve(yyjson_arr_size(v));
                size_t idx, max;
                yyjson_val* rVal;
                yyjson_arr_foreach(v, idx, max, rVal) {
                    if (yyjson_is_obj(rVal)) {
                        TextRun tr;
                        yyjson_val* rv;
                        if ((rv = yyjson_obj_get(rVal, "text")) && yyjson_is_str(rv)) tr.text = yyjson_get_str(rv);
                        if ((rv = yyjson_obj_get(rVal, "dx"))) tr.dx = yyjson_get_num(rv);
                        if ((rv = yyjson_obj_get(rVal, "dy"))) tr.dy = yyjson_get_num(rv);
                        if ((rv = yyjson_obj_get(rVal, "color"))) tr.color = (uint32_t)yyjson_get_num(rv);
                        if ((rv = yyjson_obj_get(rVal, "size"))) tr.fontSize = yyjson_get_num(rv);
                        if ((rv = yyjson_obj_get(rVal, "weight"))) tr.weight = (int)yyjson_get_num(rv);
                        if ((rv = yyjson_obj_get(rVal, "style"))) tr.style = (int)yyjson_get_num(rv);
                        runsList.push_back(std::move(tr));
                    }
                }
                if (!runsList.empty()) typo.runs = std::move(runsList);
            }

            return typo;
        }

        static BoxDecoration parseDecoration(yyjson_val* val) {
            BoxDecoration deco; if (!val || !yyjson_is_obj(val)) return deco; yyjson_val* v;

            if ((v = yyjson_obj_get(val, "bg"))) deco.backgroundColor = (uint32_t)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "bgImg")) && yyjson_is_str(v)) deco.backgroundImage = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "opacity"))) deco.opacity = yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "borderColor"))) deco.borderColor = (uint32_t)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "borderWidth"))) deco.borderWidth = parseEdgeInsets(v);
            if ((v = yyjson_obj_get(val, "borderStyle"))) deco.borderStyle = (int)yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "borderDash")) && yyjson_is_arr(v)) {
                std::vector<double> dashes;
                dashes.reserve(yyjson_arr_size(v));
                size_t idx, max;
                yyjson_val* dVal;
                yyjson_arr_foreach(v, idx, max, dVal) {
                    dashes.push_back(yyjson_get_num(dVal));
                }
                if (!dashes.empty()) deco.borderDash = std::move(dashes);
            }

            if ((v = yyjson_obj_get(val, "gradient")) && yyjson_is_arr(v)) {
                std::vector<int> gradColors;
                gradColors.reserve(yyjson_arr_size(v));
                size_t idx, max;
                yyjson_val* gVal;
                yyjson_arr_foreach(v, idx, max, gVal) {
                    gradColors.push_back(static_cast<int>((uint32_t)yyjson_get_num(gVal)));
                }
                if (!gradColors.empty()) deco.gradient = std::move(gradColors);
            }
            if ((v = yyjson_obj_get(val, "gradientAngle"))) deco.gradientAngle = yyjson_get_num(v);

            if ((v = yyjson_obj_get(val, "shape"))) deco.shape = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "blendMode"))) deco.blendMode = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "radius"))) deco.borderRadius = parseEdgeInsets(v);

            if ((v = yyjson_obj_get(val, "clip"))) deco.isClip = yyjson_get_bool(v);
            if ((v = yyjson_obj_get(val, "clipRule"))) deco.clipRule = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "clipSvgPath")) && yyjson_is_str(v)) deco.clipSvgPath = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "clipMath")) && yyjson_is_str(v)) deco.clipMath = yyjson_get_str(v);

            if ((v = yyjson_obj_get(val, "shadow")) && yyjson_is_obj(v)) {
                CanvasShadow shadow;
                yyjson_val* sv;
                if ((sv = yyjson_obj_get(v, "color"))) shadow.color = (uint32_t)yyjson_get_num(sv);
                if ((sv = yyjson_obj_get(v, "dx"))) shadow.offsetX = yyjson_get_num(sv);
                if ((sv = yyjson_obj_get(v, "dy"))) shadow.offsetY = yyjson_get_num(sv);
                if ((sv = yyjson_obj_get(v, "blur"))) shadow.blurRadius = yyjson_get_num(sv);
                if ((sv = yyjson_obj_get(v, "spread"))) shadow.spreadRadius = yyjson_get_num(sv);
                if ((sv = yyjson_obj_get(v, "isDrop"))) shadow.isDropShadow = yyjson_get_bool(sv);
                if ((sv = yyjson_obj_get(v, "type"))) shadow.shadowType = (int)yyjson_get_num(sv);
                if ((sv = yyjson_obj_get(v, "gradient")) && yyjson_is_arr(sv)) {
                    std::vector<int> sGrad;
                    sGrad.reserve(yyjson_arr_size(sv));
                    size_t idx, max;
                    yyjson_val* gVal;
                    yyjson_arr_foreach(sv, idx, max, gVal) {
                        sGrad.push_back(static_cast<int>((uint32_t)yyjson_get_num(gVal)));
                    }
                    if (!sGrad.empty()) shadow.gradient = std::move(sGrad);
                }
                deco.shadow = std::move(shadow);
            }

            if ((v = yyjson_obj_get(val, "mirror")) && yyjson_is_obj(v)) {
                CanvasReflection mirror;
                yyjson_val* mv;
                if ((mv = yyjson_obj_get(v, "distance"))) mirror.distance = yyjson_get_num(mv);
                if ((mv = yyjson_obj_get(v, "blur"))) mirror.blurRadius = yyjson_get_num(mv);
                if ((mv = yyjson_obj_get(v, "opacity"))) mirror.opacity = yyjson_get_num(mv);
                if ((mv = yyjson_obj_get(v, "fadeDir"))) mirror.fadeDirection = (int)yyjson_get_num(mv);
                if ((mv = yyjson_obj_get(v, "fadeGradient")) && yyjson_is_arr(mv)) {
                    std::vector<int> fGrad;
                    fGrad.reserve(yyjson_arr_size(mv));
                    size_t idx, max;
                    yyjson_val* gVal;
                    yyjson_arr_foreach(mv, idx, max, gVal) {
                        fGrad.push_back(static_cast<int>((uint32_t)yyjson_get_num(gVal)));
                    }
                    if (!fGrad.empty()) mirror.fadeGradient = std::move(fGrad);
                }
                deco.mirror = std::move(mirror);
            }

            return deco;
        }

        static std::optional<TransformMatrix> parseTransform(yyjson_val* val) {
            if (!val || !yyjson_is_obj(val)) return std::nullopt;
            TransformMatrix t; yyjson_val* v;
            if ((v = yyjson_obj_get(val, "sx"))) t.scaleX = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "sy"))) t.scaleY = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "rz"))) t.rotateZ = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "tx"))) t.translateX = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "ty"))) t.translateY = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "skx"))) t.skewX = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "sky"))) t.skewY = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "ox"))) t.originX = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "oy"))) t.originY = yyjson_get_num(v);
            return t;
        }

        static std::optional<TransitionProps> parseTransition(yyjson_val* val) {
            if (!val || !yyjson_is_obj(val)) return std::nullopt;
            TransitionProps tr; yyjson_val* v;
            if ((v = yyjson_obj_get(val, "duration"))) tr.durationMs = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "delay"))) tr.delayMs = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "timing"))) tr.timingFunction = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "fromOpacity"))) tr.fromOpacity = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "fromScale"))) tr.fromScale = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "fromX"))) tr.fromX = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "fromY"))) tr.fromY = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "fromRotate"))) tr.fromRotate = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "loop"))) tr.loop = yyjson_get_bool(v);
            if ((v = yyjson_obj_get(val, "yoyo"))) tr.yoyo = yyjson_get_bool(v);
            return tr;
        }

        static std::optional<SpanningRules> parseSpanningRules(yyjson_val* val) {
            if (!val || !yyjson_is_obj(val)) return std::nullopt;
            SpanningRules sr; yyjson_val* v;
            if ((v = yyjson_obj_get(val, "breakBefore"))) sr.pageBreakBefore = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "breakInside"))) sr.pageBreakInside = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "breakAfter"))) sr.pageBreakAfter = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "safeThreshold"))) sr.safeThreshold = yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "orphans"))) sr.orphans = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "widows"))) sr.widows = (int)yyjson_get_num(v);
            return sr;
        }

        static SuperContainer parseContainer(yyjson_val* val) {
            SuperContainer node;
            if (!val || !yyjson_is_obj(val)) return node;

            yyjson_val* v;
            if ((v = yyjson_obj_get(val, "id")) && yyjson_is_str(v)) node.id = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "type"))) node.type = (int)yyjson_get_num(v);
            if ((v = yyjson_obj_get(val, "content")) && yyjson_is_str(v)) node.content = yyjson_get_str(v);

            if ((v = yyjson_obj_get(val, "linkUrl")) && yyjson_is_str(v)) node.linkUrl = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "bookmark")) && yyjson_is_str(v)) node.bookmarkTitle = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "semanticTag")) && yyjson_is_str(v)) node.semanticTag = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "fallbackText")) && yyjson_is_str(v)) node.fallbackText = yyjson_get_str(v);
            if ((v = yyjson_obj_get(val, "rasterMask")) && yyjson_is_str(v)) node.rasterMask = yyjson_get_str(v);

            if ((v = yyjson_obj_get(val, "constraints"))) node.constraints = parseConstraints(v);
            if ((v = yyjson_obj_get(val, "position"))) node.position = parsePosition(v);
            if ((v = yyjson_obj_get(val, "margin"))) node.margin = parseEdgeInsets(v);
            if ((v = yyjson_obj_get(val, "padding"))) node.padding = parseEdgeInsets(v);
            if ((v = yyjson_obj_get(val, "marginPct"))) node.marginPercent = parseEdgeInsets(v);
            if ((v = yyjson_obj_get(val, "paddingPct"))) node.paddingPercent = parseEdgeInsets(v);
            if ((v = yyjson_obj_get(val, "marginAuto"))) node.marginAuto = yyjson_get_bool(v);
            if ((v = yyjson_obj_get(val, "layout"))) node.layout = parseLayout(v);
            if ((v = yyjson_obj_get(val, "transform"))) node.transform = parseTransform(v);
            if ((v = yyjson_obj_get(val, "transition"))) node.transition = parseTransition(v);
            if ((v = yyjson_obj_get(val, "spanningRules"))) node.spanningRules = parseSpanningRules(v);
            if ((v = yyjson_obj_get(val, "decoration"))) node.decoration = parseDecoration(v);
            if ((v = yyjson_obj_get(val, "typography"))) node.typography = parseTypography(v);

            if ((v = yyjson_obj_get(val, "imgProps"))) {
                ImageProps img;
                yyjson_val* imgVal;
                if ((imgVal = yyjson_obj_get(v, "fit"))) img.fit = (int)yyjson_get_num(imgVal);
                if ((imgVal = yyjson_obj_get(v, "align"))) img.alignment = (int)yyjson_get_num(imgVal);
                if ((imgVal = yyjson_obj_get(v, "dpi"))) img.dpi = (int)yyjson_get_num(imgVal);
                node.imageProps = img;
            }

            if ((v = yyjson_obj_get(val, "svgProps"))) {
                SvgProps svg;
                yyjson_val* svgVal;
                if ((svgVal = yyjson_obj_get(v, "viewBox")) && yyjson_is_str(svgVal)) svg.viewBox = yyjson_get_str(svgVal);
                if ((svgVal = yyjson_obj_get(v, "fill"))) svg.fill = (int)yyjson_get_num(svgVal);
                if ((svgVal = yyjson_obj_get(v, "stroke"))) svg.stroke = (int)yyjson_get_num(svgVal);
                if ((svgVal = yyjson_obj_get(v, "strokeW"))) svg.strokeWidth = yyjson_get_num(svgVal);
                if ((svgVal = yyjson_obj_get(v, "strokeCap"))) svg.strokeCap = (int)yyjson_get_num(svgVal);
                if ((svgVal = yyjson_obj_get(v, "strokeJoin"))) svg.strokeJoin = (int)yyjson_get_num(svgVal);
                node.svgProps = svg;
            }

            if ((v = yyjson_obj_get(val, "lottieProps"))) {
                LottieProps lottie;
                yyjson_val* lotVal;
                if ((lotVal = yyjson_obj_get(v, "autoplay"))) lottie.autoplay = yyjson_get_bool(lotVal);
                if ((lotVal = yyjson_obj_get(v, "loop"))) lottie.loop = yyjson_get_bool(lotVal);
                if ((lotVal = yyjson_obj_get(v, "speed"))) lottie.speed = yyjson_get_num(lotVal);
                if ((lotVal = yyjson_obj_get(v, "fps"))) lottie.fps = (int)yyjson_get_num(lotVal);
                if ((lotVal = yyjson_obj_get(v, "frame"))) lottie.initialFrame = (int)yyjson_get_num(lotVal);
                if ((lotVal = yyjson_obj_get(v, "endFrame"))) lottie.endFrame = (int)yyjson_get_num(lotVal);
                node.lottieProps = lottie;
            }

            if ((v = yyjson_obj_get(val, "formField"))) {
                FormFieldData form;
                yyjson_val* formVal;
                if ((formVal = yyjson_obj_get(v, "fieldType"))) form.fieldType = (int)yyjson_get_num(formVal);
                if ((formVal = yyjson_obj_get(v, "name")) && yyjson_is_str(formVal)) form.name = yyjson_get_str(formVal);
                if ((formVal = yyjson_obj_get(v, "value")) && yyjson_is_str(formVal)) form.value = yyjson_get_str(formVal);
                node.formField = form;
            }

            yyjson_val* children_val = yyjson_obj_get(val, "children");
            if (children_val && yyjson_is_arr(children_val)) {
                node.children.reserve(yyjson_arr_size(children_val));
                size_t idx, max; yyjson_val *child;
                yyjson_arr_foreach(children_val, idx, max, child) {
                    node.children.push_back(parseContainer(child));
                }
            }
            return node;
        }
    };
} // namespace CoreCanvas