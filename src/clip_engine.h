// FILE: src/clip_engine.h
// PURPOSE: Generates PDF clipping paths and SVG XML masks for Shadow Rasterization.
// 🚀 FAANG FIX: Decoupled SVG XML generation from PDF command logic for reusability.

#pragma once
#include <string>
#include <sstream>
#include <algorithm>
#include <cstring>
#include <cmath>
#include "config.h"
#include "nanosvg.h"

namespace CoreCanvas {

    class ClipEngine {
    public:
        // ============================================================================
        // 🔥 NEW HELPER: Sirf Raw SVG XML banayega (Jisse ShadowEngine bhi use kar sake)
        // ============================================================================
        static std::string generateClipSvgXml(double boxW, double boxH, const BoxDecoration& deco) {
            std::string d_path = "";

            if (deco.shape == 1) { // Circle
                double r = std::min(boxW, boxH) / 2.0;
                double cx = boxW / 2.0;
                double cy = boxH / 2.0;
                std::ostringstream path;
                path << "M " << cx << " " << (cy - r) << " ";
                path << "A " << r << " " << r << " 0 1 1 " << cx << " " << (cy + r) << " ";
                path << "A " << r << " " << r << " 0 1 1 " << cx << " " << (cy - r) << " Z";
                d_path = path.str();
            }
            else if (deco.borderRadius.has_value()) { // Rounded Rectangle
                const auto& r = deco.borderRadius.value();
                double maxR = std::min(boxW, boxH) / 2.0;
                double tl = std::min(r.top, maxR), tr = std::min(r.right, maxR);
                double br = std::min(r.bottom, maxR), bl = std::min(r.left, maxR);

                if (tl > 0 || tr > 0 || br > 0 || bl > 0) {
                    std::ostringstream path;
                    path << "M " << tl << " 0 L " << (boxW - tr) << " 0 ";
                    if (tr > 0) path << "A " << tr << " " << tr << " 0 0 1 " << boxW << " " << tr << " ";
                    path << "L " << boxW << " " << (boxH - br) << " ";
                    if (br > 0) path << "A " << br << " " << br << " 0 0 1 " << (boxW - br) << " " << boxH << " ";
                    path << "L " << bl << " " << boxH << " ";
                    if (bl > 0) path << "A " << bl << " " << bl << " 0 0 1 0 " << (boxH - bl) << " ";
                    path << "L 0 " << tl << " ";
                    if (tl > 0) path << "A " << tl << " " << tl << " 0 0 1 " << tl << " 0 Z";
                    d_path = path.str();
                }
            }
            else if (deco.clipMath.has_value() && deco.isClip) { // Custom Math
                d_path = deco.clipMath.value();
            }
            else if (deco.clipSvgPath.has_value() && deco.isClip) { // Raw Custom SVG
                d_path = deco.clipSvgPath.value();
            }

            if (d_path.empty()) return "";

            // NanoSVG Shield for Raw Files vs Math Path
            if (d_path.find("<svg") != std::string::npos || d_path.find("<?xml") != std::string::npos) {
                return d_path;
            } else {
                return "<svg><path d=\"" + d_path + "\"/></svg>";
            }
        }

        // ============================================================================
        // ✂️ ORIGINAL FUNCTION: PDF ke liye Bezier curves banata hai
        // ============================================================================
        static std::string generateClipPath(double boxW, double boxH, double globalX, double globalY, double pageHeight, const BoxDecoration& deco) {
            std::string svgXml = generateClipSvgXml(boxW, boxH, deco);
            if (svgXml.empty()) return "";

            char* xmlCopy = new char[svgXml.length() + 1];
            std::strcpy(xmlCopy, svgXml.c_str());

            NSVGimage* image = nsvgParse(xmlCopy, "px", 96.0f);
            delete[] xmlCopy;

            if (!image) return "";

            double scaleX = 1.0;
            double scaleY = 1.0;

            // Auto-Scaling for Custom Vectors
            if (deco.clipMath.has_value() || deco.clipSvgPath.has_value()) {
                float bounds[4] = {1e6, 1e6, -1e6, -1e6};
                for (NSVGshape* shape = image->shapes; shape != NULL; shape = shape->next) {
                    if (shape->bounds[0] < bounds[0]) bounds[0] = shape->bounds[0];
                    if (shape->bounds[1] < bounds[1]) bounds[1] = shape->bounds[1];
                    if (shape->bounds[2] > bounds[2]) bounds[2] = shape->bounds[2];
                    if (shape->bounds[3] > bounds[3]) bounds[3] = shape->bounds[3];
                }
                double actualSvgW = bounds[2] - bounds[0];
                double actualSvgH = bounds[3] - bounds[1];

                if (actualSvgW > 0 && actualSvgH > 0) {
                    scaleX = boxW / actualSvgW;
                    scaleY = boxH / actualSvgH;
                }
            }

            double localY = globalY - (std::floor(globalY / pageHeight) * pageHeight);
            double pdfAnchorY = pageHeight - localY;

            std::ostringstream pdfCmd;
            for (NSVGshape* shape = image->shapes; shape != NULL; shape = shape->next) {
                for (NSVGpath* path = shape->paths; path != NULL; path = path->next) {

                    for (int i = 0; i < path->npts - 1; i += 3) {
                        float* p = &path->pts[i * 2];
                        if (i == 0) {
                            pdfCmd << (globalX + (p[0] * scaleX)) << " " << (pdfAnchorY - (p[1] * scaleY)) << " m\n";
                        }
                        pdfCmd << (globalX + (p[2] * scaleX)) << " " << (pdfAnchorY - (p[3] * scaleY)) << " "
                               << (globalX + (p[4] * scaleX)) << " " << (pdfAnchorY - (p[5] * scaleY)) << " "
                               << (globalX + (p[6] * scaleX)) << " " << (pdfAnchorY - (p[7] * scaleY)) << " c\n";
                    }
                    if (path->closed) {
                        pdfCmd << "h\n";
                    }
                }
            }

            nsvgDelete(image);
            return pdfCmd.str();
        }
    };

} // namespace CoreCanvas