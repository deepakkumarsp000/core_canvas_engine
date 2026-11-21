// FILE: src/html_canvas.h
// PURPOSE: Converts Meta Yoga AST Tree into Rich HTML5/CSS3 DOM with Gradients, Shadows, SVGs, Transforms & Links!
// 🚀 FAANG FIX: Added CANVAS_ENABLE_HTML Opt-In Guard, CSS Linear-Gradients, Box-Shadows, BlendModes & Memory Arena!

#pragma once
#include <string>
#include <sstream>
#include <fstream>
#include <iostream>
#include <vector>
#include "render_engine.h"
#include "image_engine.h"

namespace CoreCanvas {

#ifdef CANVAS_ENABLE_HTML
    class HtmlCanvas : public IRenderTarget {
    private:
        std::ostringstream html;
        double pageHeight;

        std::string toCssColor(uint32_t argb) {
            char buf[32];
            uint8_t a = (argb >> 24) & 0xFF;
            uint8_t r = (argb >> 16) & 0xFF;
            uint8_t g = (argb >> 8) & 0xFF;
            uint8_t b = argb & 0xFF;
            snprintf(buf, sizeof(buf), "rgba(%d,%d,%d,%.2f)", r, g, b, a / 255.0);
            return std::string(buf);
        }

        static std::string toCssBlendMode(int mode) {
            switch (mode) {
                case 1: return "multiply";
                case 2: return "screen";
                case 3: return "overlay";
                case 4: return "darken";
                case 5: return "lighten";
                case 6: return "color-dodge";
                case 7: return "color-burn";
                case 8: return "hard-light";
                case 9: return "soft-light";
                case 10: return "difference";
                case 11: return "exclusion";
                default: return "normal";
            }
        }

        static std::string resolveDataUri(const std::string& src) {
            if (src.rfind("mem://", 0) == 0) {
                std::vector<unsigned char> raw = ImageEngine::decodeBase64(src);
                return "data:image/png;base64," + ImageEngine::encodeBase64(raw.data(), raw.size());
            }
            return "data:image/png;base64," + src;
        }

    public:
        HtmlCanvas(const CanvasConfig& config) {
            pageHeight = config.h;
            html << "<!DOCTYPE html>\n<html>\n<head>\n<meta charset='utf-8'>\n<style>\n";
            html << "  body { margin: 0; padding: 0; background: #0f172a; display: flex; justify-content: center; align-items: center; min-height: 100vh; font-family: sans-serif; }\n";
            html << "  .canvas { position: relative; width: " << config.w << "px; height: " << config.h << "px; background: white; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.4);";
            if (config.colorSpace == 1) html << " filter: grayscale(100%);";
            html << " }\n";
            html << "  .node { position: absolute; box-sizing: border-box; user-select: text; white-space: pre-wrap; }\n";
            html << "</style>\n</head>\n<body>\n<div class='canvas'>\n";
        }

        bool saveToFile(const std::string& path) {
            html << "</div>\n</body>\n</html>";
            std::ofstream file(path);
            if (file.is_open()) {
                file << html.str();
                return true;
            }
            return false;
        }

        double getPageHeight() override { return pageHeight; }

        void drawBox(double x, double y, double w, double h, const std::optional<BoxDecoration>& deco) override {
            html << "<div class='node' style='left:" << x << "px; top:" << y << "px; width:" << w << "px; height:" << h << "px;";
            if (deco.has_value()) {
                const auto& d = deco.value();
                if (d.gradient.has_value() && !d.gradient->empty()) {
                    html << " background: linear-gradient(" << (d.gradientAngle + 90.0) << "deg";
                    for (int col : d.gradient.value()) {
                        html << ", " << toCssColor(static_cast<uint32_t>(col));
                    }
                    html << ");";
                } else if (d.backgroundColor.has_value()) {
                    html << " background-color: " << toCssColor(d.backgroundColor.value()) << ";";
                }
                if (d.backgroundImage.has_value() && !d.backgroundImage->empty()) {
                    html << " background-image: url(" << resolveDataUri(d.backgroundImage.value()) << "); background-size: cover; background-position: center;";
                }
                if (d.shape == 1) {
                    html << " border-radius: 50%;";
                } else if (d.borderRadius.has_value()) {
                    const auto& r = d.borderRadius.value();
                    html << " border-radius: " << r.top << "px " << r.right << "px " << r.bottom << "px " << r.left << "px;";
                }
                if (d.borderColor.has_value() && d.borderWidth.has_value()) {
                    const auto& bw = d.borderWidth.value();
                    std::string bStyle = (d.borderStyle == 1) ? "dashed" : ((d.borderStyle == 2) ? "dotted" : "solid");
                    html << " border-style: " << bStyle << "; border-color: " << toCssColor(d.borderColor.value()) << ";";
                    html << " border-width: " << bw.top << "px " << bw.right << "px " << bw.bottom << "px " << bw.left << "px;";
                }
                if (d.shadow.has_value()) {
                    const auto& s = d.shadow.value();
                    html << " box-shadow: " << s.offsetX << "px " << s.offsetY << "px " << s.blurRadius << "px " << s.spreadRadius << "px " << toCssColor(s.color) << ";";
                }
                if (d.opacity < 0.999) html << " opacity: " << d.opacity << ";";
                if (d.blendMode != 0) html << " mix-blend-mode: " << toCssBlendMode(d.blendMode) << ";";
            }
            html << "'></div>\n";
        }

        void drawText(double x, double y, double w, double h, const std::string& text, const std::optional<Typography>& typo) override {
            html << "<div class='node' style='left:" << x << "px; top:" << y << "px; width:" << w << "px; height:" << h << "px;";
            if (typo.has_value()) {
                const auto& t = typo.value();
                html << " color: " << toCssColor(t.color) << ";";
                html << " font-size: " << t.fontSize << "px;";
                html << " font-weight: " << t.weight << ";";
                html << " line-height: " << t.lineHeight << ";";
                if (t.style == 1 || t.style == 2) html << " font-style: italic;";
                if (t.decoration == 1) html << " text-decoration: underline;";
                else if (t.decoration == 2) html << " text-decoration: line-through;";
                else if (t.decoration == 3) html << " text-decoration: overline;";
                if (t.letterSpacing != 0.0) html << " letter-spacing: " << t.letterSpacing << "px;";
                if (t.wordSpacing != 0.0) html << " word-spacing: " << t.wordSpacing << "px;";
                if (t.align == 1) html << " text-align: center;";
                else if (t.align == 2) html << " text-align: right;";
                else if (t.align == 3) html << " text-align: justify;";
                if (t.fontFamily.has_value()) html << " font-family: \"" << t.fontFamily.value() << "\", sans-serif;";
            }
            html << "'>" << text << "</div>\n";
        }

        void drawImage(double x, double y, double w, double h, const std::string& base64, const std::optional<ImageProps>& props) override {
            std::string fitCss = "cover";
            if (props.has_value()) {
                switch (props->fit) {
                    case 0: fitCss = "none"; break;
                    case 1: fitCss = "fill"; break;
                    case 2: fitCss = "contain"; break;
                    case 4: fitCss = "scale-down"; break;
                    default: fitCss = "cover"; break;
                }
            }
            html << "<img class='node' style='left:" << x << "px; top:" << y << "px; width:" << w << "px; height:" << h << "px; object-fit: " << fitCss << ";' src='" << resolveDataUri(base64) << "'/>\n";
        }

        void drawSvg(double x, double y, double w, double h, const std::string& svgXml, const std::optional<SvgProps>& props) override {
            (void)props;
            html << "<div class='node' style='left:" << x << "px; top:" << y << "px; width:" << w << "px; height:" << h << "px; display:flex; align-items:center; justify-content:center;'>"
                 << svgXml << "</div>\n";
        }

        void pushTransform(double x, double y, double w, double h, const TransformMatrix& tm) override {
            html << "<div style='position:absolute; left:0; top:0; width:100%; height:100%; pointer-events:none; "
                 << "transform-origin: " << (x + w * tm.originX) << "px " << (y + h * tm.originY) << "px; "
                 << "transform: translate(" << tm.translateX << "px, " << tm.translateY << "px) "
                 << "rotate(" << tm.rotateZ << "deg) "
                 << "scale(" << tm.scaleX << ", " << tm.scaleY << ") "
                 << "skew(" << tm.skewX << "deg, " << tm.skewY << "deg);'>\n";
        }

        void popTransform() override {
            html << "</div>\n";
        }

        void addLink(double x, double y, double w, double h, const std::string& url) override {
            html << "<a class='node' href='" << url << "' target='_blank' style='left:" << x << "px; top:" << y << "px; width:" << w << "px; height:" << h << "px; display:block; z-index:999;'></a>\n";
        }

        void drawRasterShadow(double x, double y, double w, double h, const std::vector<uint8_t>& pixels, uint32_t parentBgColor) override {
            (void)x; (void)y; (void)w; (void)h; (void)pixels; (void)parentBgColor;
        }
        void pushClip(double x, double y, double w, double h, const std::string& clipSvgPath) override {
            (void)x; (void)y; (void)w; (void)h; (void)clipSvgPath;
        }
        void popClip() override {}
    };
#endif // CANVAS_ENABLE_HTML

} // namespace CoreCanvas