// FILE: src/param_transform.h
// PURPOSE: Dart ke TransformMatrix ko C++ struct me map karna for 2D transformations (scale, rotate, skew, translate).
// 🚀 FAANG FIX: Defaults explicitly set to match identity matrix (No-op) state, exactly like Dart.

#pragma once

namespace CoreCanvas {

// ============================================================================
// 🔄 TRANSFORM MATRIX (For 2D Canvas Operations)
// ============================================================================
    struct TransformMatrix {
        double scaleX = 1.0;
        double scaleY = 1.0;
        double rotateZ = 0.0;
        double translateX = 0.0;
        double translateY = 0.0;
        double skewX = 0.0;
        double skewY = 0.0;
        double originX = 0.5;
        double originY = 0.5;
    };

} // namespace CoreCanvas