// FILE: src/layout_engine.h
// PURPOSE: Meta Yoga Flexbox Tree Builder (Maps 100% of SuperContainer Constraints, Padding, Borders & Flexbox)
// 🚀 FAANG FIX: Cross-Platform Logging Shield + YGNodeStyleSetBorder Sync & Zero Log Bloat!

#pragma once
#include <yoga/Yoga.h>

#ifdef __ANDROID__
#include <android/log.h>
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "CANVAS_ENGINE", __VA_ARGS__)
#else
#include <cstdio>
#define LOGD(...) do { fprintf(stdout, __VA_ARGS__); fprintf(stdout, "\n"); } while(0)
#endif

#include "config.h"
#include "font_engine.h"

namespace CoreCanvas {

    class LayoutEngine {
    private:
        static YGFlexDirection mapDir(int dir) {
            switch(dir) {
                case 1: return YGFlexDirectionColumnReverse;
                case 2: return YGFlexDirectionRow;
                case 3: return YGFlexDirectionRowReverse;
                default: return YGFlexDirectionColumn;
            }
        }
        static YGJustify mapJustify(int j) {
            switch(j) {
                case 1: return YGJustifyCenter;
                case 2: return YGJustifyFlexEnd;
                case 3: return YGJustifySpaceBetween;
                case 4: return YGJustifySpaceAround;
                case 5: return YGJustifySpaceEvenly;
                default: return YGJustifyFlexStart;
            }
        }
        static YGAlign mapAlign(int a) {
            switch(a) {
                case 1: return YGAlignFlexStart;
                case 2: return YGAlignCenter;
                case 3: return YGAlignFlexEnd;
                case 4: return YGAlignStretch;
                case 5: return YGAlignBaseline;
                case 6: return YGAlignSpaceBetween;
                case 7: return YGAlignSpaceAround;
                default: return YGAlignAuto;
            }
        }
        static YGDirection mapLayoutDirection(int ld) {
            switch(ld) {
                case 1: return YGDirectionLTR;
                case 2: return YGDirectionRTL;
                default: return YGDirectionInherit;
            }
        }
        static YGOverflow mapOverflow(int o) {
            switch(o) {
                case 1: return YGOverflowHidden;
                case 2: return YGOverflowScroll;
                default: return YGOverflowVisible;
            }
        }

    public:
        static YGNodeRef buildYogaTree(const SuperContainer& container, bool isRoot = false) {
            YGNodeRef node = YGNodeNew();
            YGNodeSetContext(node, (void*)&container);

            if (container.type == 1) {
                YGNodeSetMeasureFunc(node, FontEngine::yogaMeasureCallback);
            }

            // 1. Box Constraints (Width, Height, Min/Max, Percent & AspectRatio)
            if (container.constraints.has_value()) {
                const auto& c = container.constraints.value();

                if (c.width.has_value()) YGNodeStyleSetWidth(node, c.width.value());
                if (c.height.has_value()) YGNodeStyleSetHeight(node, c.height.value());
                if (c.minWidth.has_value()) YGNodeStyleSetMinWidth(node, c.minWidth.value());
                if (c.maxWidth.has_value()) YGNodeStyleSetMaxWidth(node, c.maxWidth.value());
                if (c.minHeight.has_value()) YGNodeStyleSetMinHeight(node, c.minHeight.value());
                if (c.maxHeight.has_value()) YGNodeStyleSetMaxHeight(node, c.maxHeight.value());

                if (!isRoot) {
                    if (c.widthPercent.has_value()) YGNodeStyleSetWidthPercent(node, c.widthPercent.value());
                    if (c.heightPercent.has_value()) YGNodeStyleSetHeightPercent(node, c.heightPercent.value());
                    if (c.minWidthPercent.has_value()) YGNodeStyleSetMinWidthPercent(node, c.minWidthPercent.value());
                    if (c.maxWidthPercent.has_value()) YGNodeStyleSetMaxWidthPercent(node, c.maxWidthPercent.value());
                    if (c.minHeightPercent.has_value()) YGNodeStyleSetMinHeightPercent(node, c.minHeightPercent.value());
                    if (c.maxHeightPercent.has_value()) YGNodeStyleSetMaxHeightPercent(node, c.maxHeightPercent.value());
                }
                if (c.aspectRatio.has_value()) YGNodeStyleSetAspectRatio(node, c.aspectRatio.value());
            }

            // 2. Padding & Padding Percent
            if (container.padding.has_value()) {
                const auto& p = container.padding.value();
                YGNodeStyleSetPadding(node, YGEdgeTop, p.top);
                YGNodeStyleSetPadding(node, YGEdgeRight, p.right);
                YGNodeStyleSetPadding(node, YGEdgeBottom, p.bottom);
                YGNodeStyleSetPadding(node, YGEdgeLeft, p.left);
            }

            if (container.paddingPercent.has_value()) {
                const auto& p = container.paddingPercent.value();
                YGNodeStyleSetPaddingPercent(node, YGEdgeTop, p.top);
                YGNodeStyleSetPaddingPercent(node, YGEdgeRight, p.right);
                YGNodeStyleSetPaddingPercent(node, YGEdgeBottom, p.bottom);
                YGNodeStyleSetPaddingPercent(node, YGEdgeLeft, p.left);
            }

            // 🔥 3. Border Width Sync (Prevents child layout from overlapping thick borders!)
            if (container.decoration.has_value() && container.decoration->borderWidth.has_value()) {
                const auto& bw = container.decoration->borderWidth.value();
                if (bw.top > 0) YGNodeStyleSetBorder(node, YGEdgeTop, bw.top);
                if (bw.right > 0) YGNodeStyleSetBorder(node, YGEdgeRight, bw.right);
                if (bw.bottom > 0) YGNodeStyleSetBorder(node, YGEdgeBottom, bw.bottom);
                if (bw.left > 0) YGNodeStyleSetBorder(node, YGEdgeLeft, bw.left);
            }

            // 4. Margin & Margin Auto
            if (container.marginAuto) {
                YGNodeStyleSetMarginAuto(node, YGEdgeAll);
            } else {
                if (container.margin.has_value()) {
                    const auto& m = container.margin.value();
                    YGNodeStyleSetMargin(node, YGEdgeTop, m.top);
                    YGNodeStyleSetMargin(node, YGEdgeRight, m.right);
                    YGNodeStyleSetMargin(node, YGEdgeBottom, m.bottom);
                    YGNodeStyleSetMargin(node, YGEdgeLeft, m.left);
                }
                if (container.marginPercent.has_value()) {
                    const auto& m = container.marginPercent.value();
                    YGNodeStyleSetMarginPercent(node, YGEdgeTop, m.top);
                    YGNodeStyleSetMarginPercent(node, YGEdgeRight, m.right);
                    YGNodeStyleSetMarginPercent(node, YGEdgeBottom, m.bottom);
                    YGNodeStyleSetMarginPercent(node, YGEdgeLeft, m.left);
                }
            }

            // 5. Flexbox Layout Properties
            if (container.layout.has_value()) {
                const auto& l = container.layout.value();

                YGNodeStyleSetDisplay(node, l.display == 1 ? YGDisplayNone : YGDisplayFlex);
                YGNodeStyleSetFlexDirection(node, mapDir(l.direction));
                YGNodeStyleSetJustifyContent(node, mapJustify(l.justifyContent));

                YGAlign itemsAlign = (l.alignItems == 0) ? YGAlignStretch : mapAlign(l.alignItems);
                YGNodeStyleSetAlignItems(node, itemsAlign);

                YGAlign contentAlign = (l.alignContent == 0) ? YGAlignFlexStart : mapAlign(l.alignContent);
                YGNodeStyleSetAlignContent(node, contentAlign);

                YGNodeStyleSetAlignSelf(node, mapAlign(l.alignSelf));
                YGNodeStyleSetDirection(node, mapLayoutDirection(l.layoutDirection));
                YGNodeStyleSetFlexWrap(node, static_cast<YGWrap>(l.wrap));
                YGNodeStyleSetFlexGrow(node, l.flexGrow);
                YGNodeStyleSetFlexShrink(node, l.flexShrink);
                YGNodeStyleSetOverflow(node, mapOverflow(l.overflow));

                if (l.gap > 0) YGNodeStyleSetGap(node, YGGutterAll, l.gap);
                if (l.rowGap > 0) YGNodeStyleSetGap(node, YGGutterRow, l.rowGap);
                if (l.columnGap > 0) YGNodeStyleSetGap(node, YGGutterColumn, l.columnGap);

                if (l.flexBasis.has_value()) YGNodeStyleSetFlexBasis(node, l.flexBasis.value());
                if (l.flexBasisPercent.has_value()) YGNodeStyleSetFlexBasisPercent(node, l.flexBasisPercent.value());
                if (l.isFlexBasisAuto) YGNodeStyleSetFlexBasisAuto(node);
            }

            // 6. Positioning (Relative, Absolute, Static)
            if (container.position.has_value()) {
                const auto& pos = container.position.value();

                if (pos.type == 1) {
                    YGNodeStyleSetPositionType(node, YGPositionTypeAbsolute);
                } else {
                    YGNodeStyleSetPositionType(node, YGPositionTypeRelative);
                }

                if (pos.type != 2) {
                    if (pos.top.has_value()) YGNodeStyleSetPosition(node, YGEdgeTop, pos.top.value());
                    if (pos.right.has_value()) YGNodeStyleSetPosition(node, YGEdgeRight, pos.right.value());
                    if (pos.bottom.has_value()) YGNodeStyleSetPosition(node, YGEdgeBottom, pos.bottom.value());
                    if (pos.left.has_value()) YGNodeStyleSetPosition(node, YGEdgeLeft, pos.left.value());

                    if (pos.topPercent.has_value()) YGNodeStyleSetPositionPercent(node, YGEdgeTop, pos.topPercent.value());
                    if (pos.rightPercent.has_value()) YGNodeStyleSetPositionPercent(node, YGEdgeRight, pos.rightPercent.value());
                    if (pos.bottomPercent.has_value()) YGNodeStyleSetPositionPercent(node, YGEdgeBottom, pos.bottomPercent.value());
                    if (pos.leftPercent.has_value()) YGNodeStyleSetPositionPercent(node, YGEdgeLeft, pos.leftPercent.value());
                }
            }

            for (size_t i = 0; i < container.children.size(); ++i) {
                YGNodeRef childNode = buildYogaTree(container.children[i], false);
                YGNodeInsertChild(node, childNode, i);
            }

            return node;
        }

        static void freeYogaTree(YGNodeRef rootNode) {
            if (rootNode) {
                YGNodeFreeRecursive(rootNode);
            }
        }
    };

} // namespace CoreCanvas