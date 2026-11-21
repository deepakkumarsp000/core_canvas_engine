// FILE: src/lottie_gif_engine.h
// PURPOSE: Unified C++ Engine for RLottie Vector Animations, Tweeny 31-Curve Easing & Animated GIF Export!
// 🚀 FAANG FIX: Zero-Bloat Opt-In Guards (CANVAS_ENABLE_LOTTIE / CANVAS_ENABLE_GIF) + Restored 31 Easing Curves!

#pragma once
#include <string>
#include <vector>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <cstdlib>
#include <algorithm>
#include <memory>
#include <type_traits>

#include "config.h"
#include "image_engine.h"

#ifdef CANVAS_ENABLE_GIF
#include "gif.h"
#endif

#if defined(CANVAS_ENABLE_GIF) && __has_include("tweeny.h")
#include "tweeny.h"
#define HAS_TWEENY_LIB 1
#elif defined(CANVAS_ENABLE_GIF) && __has_include("tweeny/tweeny.h")
#include "tweeny/tweeny.h"
#define HAS_TWEENY_LIB 1
#else
#define HAS_TWEENY_LIB 0
#endif

#if defined(CANVAS_ENABLE_LOTTIE) && __has_include("rlottie.h")
#include "rlottie.h"
#define HAS_RLOTTIE_LIB 1
#elif defined(CANVAS_ENABLE_LOTTIE) && __has_include("inc/rlottie.h")
#include "inc/rlottie.h"
#define HAS_RLOTTIE_LIB 1
#else
#define HAS_RLOTTIE_LIB 0
#endif

namespace CoreCanvas {

    struct TweenedNodeState {
        double opacity = 1.0;
        TransformMatrix transform;
        bool hasTransform = false;
    };

    class LottieGifEngine {
    private:
        static double analyticalCurve(int mode, double t) {
            constexpr double PI = 3.14159265358979323846;
            constexpr double c1 = 1.70158;
            constexpr double c2 = c1 * 1.525;
            constexpr double c3 = c1 + 1.0;
            constexpr double c4 = (2.0 * PI) / 3.0;
            constexpr double c5 = (2.0 * PI) / 4.5;

            auto bounceOut = [](double x) -> double {
                const double n1 = 7.5625;
                const double d1 = 2.75;
                if (x < 1.0 / d1) return n1 * x * x;
                if (x < 2.0 / d1) { x -= 1.5 / d1; return n1 * x * x + 0.75; }
                if (x < 2.5 / d1) { x -= 2.25 / d1; return n1 * x * x + 0.9375; }
                x -= 2.625 / d1;
                return n1 * x * x + 0.984375;
            };

            switch (mode) {
                case 1:  return 1.0 - std::cos((t * PI) / 2.0);
                case 2:  return std::sin((t * PI) / 2.0);
                case 3:  return -(std::cos(PI * t) - 1.0) / 2.0;
                case 4:  return t * t;
                case 5:  return 1.0 - (1.0 - t) * (1.0 - t);
                case 6:  return t < 0.5 ? 2.0 * t * t : 1.0 - std::pow(-2.0 * t + 2.0, 2.0) / 2.0;
                case 7:  return t * t * t;
                case 8:  return 1.0 - std::pow(1.0 - t, 3.0);
                case 9:  return t < 0.5 ? 4.0 * t * t * t : 1.0 - std::pow(-2.0 * t + 2.0, 3.0) / 2.0;
                case 10: return t * t * t * t;
                case 11: return 1.0 - std::pow(1.0 - t, 4.0);
                case 12: return t < 0.5 ? 8.0 * t * t * t * t : 1.0 - std::pow(-2.0 * t + 2.0, 4.0) / 2.0;
                case 13: return t * t * t * t * t;
                case 14: return 1.0 - std::pow(1.0 - t, 5.0);
                case 15: return t < 0.5 ? 16.0 * t * t * t * t * t : 1.0 - std::pow(-2.0 * t + 2.0, 5.0) / 2.0;
                case 16: return t == 0.0 ? 0.0 : std::pow(2.0, 10.0 * t - 10.0);
                case 17: return t == 1.0 ? 1.0 : 1.0 - std::pow(2.0, -10.0 * t);
                case 18: return t == 0.0 ? 0.0 : (t == 1.0 ? 1.0 : (t < 0.5 ? std::pow(2.0, 20.0 * t - 10.0) / 2.0 : (2.0 - std::pow(2.0, -20.0 * t + 10.0)) / 2.0));
                case 19: return 1.0 - std::sqrt(std::max(0.0, 1.0 - t * t));
                case 20: return std::sqrt(std::max(0.0, 1.0 - std::pow(t - 1.0, 2.0)));
                case 21: return t < 0.5 ? (1.0 - std::sqrt(std::max(0.0, 1.0 - std::pow(2.0 * t, 2.0)))) / 2.0 : (std::sqrt(std::max(0.0, 1.0 - std::pow(-2.0 * t + 2.0, 2.0))) + 1.0) / 2.0;
                case 22: return c3 * t * t * t - c1 * t * t;
                case 23: return 1.0 + c3 * std::pow(t - 1.0, 3.0) + c1 * std::pow(t - 1.0, 2.0);
                case 24: return t < 0.5 ? (std::pow(2.0 * t, 2.0) * ((c2 + 1.0) * 2.0 * t - c2)) / 2.0 : (std::pow(2.0 * t - 2.0, 2.0) * ((c2 + 1.0) * (t * 2.0 - 2.0) + c2) + 2.0) / 2.0;
                case 25: return t == 0.0 ? 0.0 : (t == 1.0 ? 1.0 : -std::pow(2.0, 10.0 * t - 10.0) * std::sin((t * 10.0 - 10.75) * c4));
                case 26: return t == 0.0 ? 0.0 : (t == 1.0 ? 1.0 : std::pow(2.0, -10.0 * t) * std::sin((t * 10.0 - 0.75) * c4) + 1.0);
                case 27: return t == 0.0 ? 0.0 : (t == 1.0 ? 1.0 : (t < 0.5 ? -(std::pow(2.0, 20.0 * t - 10.0) * std::sin((20.0 * t - 11.125) * c5)) / 2.0 : (std::pow(2.0, -20.0 * t + 10.0) * std::sin((20.0 * t - 11.125) * c5)) / 2.0 + 1.0));
                case 28: return 1.0 - bounceOut(1.0 - t);
                case 29: return bounceOut(t);
                case 30: return t < 0.5 ? (1.0 - bounceOut(1.0 - 2.0 * t)) / 2.0 : (1.0 + bounceOut(2.0 * t - 1.0)) / 2.0;
                case 0:
                default: return t;
            }
        }

#if HAS_TWEENY_LIB
        template <typename TweenObj>
        static double extractTweenStep(TweenObj& obj, uint32_t step, double fallback) {
            if constexpr (requires { obj.seek(static_cast<int32_t>(step)); }) {
                if constexpr (std::is_convertible_v<decltype(obj.seek(static_cast<int32_t>(step))), double>) {
                    return static_cast<double>(obj.seek(static_cast<int32_t>(step)));
                }
            } else if constexpr (requires { obj.at(step); }) {
                return static_cast<double>(obj.at(step));
            } else if constexpr (requires { obj.step(static_cast<int32_t>(step)); }) {
                obj.step(static_cast<int32_t>(step));
                if constexpr (requires { obj.peek(); }) return static_cast<double>(obj.peek());
                if constexpr (requires { obj.value(); }) return static_cast<double>(obj.value());
            } else if constexpr (requires { obj.build(); }) {
                auto built = obj.build();
                return extractTweenStep(built, step, fallback);
            }
            return fallback;
        }

        template <typename EasingPreset>
        static double runTweenyBuilder(EasingPreset&& preset, uint32_t step, double fallback) {
            auto tw = tweeny::from(0.0f).to(1.0f).during(static_cast<uint32_t>(1000));
            tw.via(preset);
            double val = extractTweenStep(tw, step, fallback);
            if (step > 0 && step < 995 && (std::abs(val - 1.0) < 1e-5 || std::abs(val - 0.0) < 1e-5) && std::abs(fallback - val) > 0.02) {
                return fallback;
            }
            return val;
        }
#endif

    public:
        static double evaluateCurve(int timingFunction, double t) {
            t = std::clamp(t, 0.0, 1.0);
            if (t <= 0.0) return 0.0;
            if (t >= 1.0) return 1.0;

            double fallback = analyticalCurve(timingFunction, t);
#if HAS_TWEENY_LIB
            uint32_t step = static_cast<uint32_t>(std::round(t * 1000.0));
            switch (timingFunction) {
                case 0:  return runTweenyBuilder(tweeny::easing::linear, step, fallback);
                case 1:  return runTweenyBuilder(tweeny::easing::sinusoidalIn, step, fallback);
                case 2:  return runTweenyBuilder(tweeny::easing::sinusoidalOut, step, fallback);
                case 3:  return runTweenyBuilder(tweeny::easing::sinusoidalInOut, step, fallback);
                case 4:  return runTweenyBuilder(tweeny::easing::quadraticIn, step, fallback);
                case 5:  return runTweenyBuilder(tweeny::easing::quadraticOut, step, fallback);
                case 6:  return runTweenyBuilder(tweeny::easing::quadraticInOut, step, fallback);
                case 7:  return runTweenyBuilder(tweeny::easing::cubicIn, step, fallback);
                case 8:  return runTweenyBuilder(tweeny::easing::cubicOut, step, fallback);
                case 9:  return runTweenyBuilder(tweeny::easing::cubicInOut, step, fallback);
                case 10: return runTweenyBuilder(tweeny::easing::quarticIn, step, fallback);
                case 11: return runTweenyBuilder(tweeny::easing::quarticOut, step, fallback);
                case 12: return runTweenyBuilder(tweeny::easing::quarticInOut, step, fallback);
                case 13: return runTweenyBuilder(tweeny::easing::quinticIn, step, fallback);
                case 14: return runTweenyBuilder(tweeny::easing::quinticOut, step, fallback);
                case 15: return runTweenyBuilder(tweeny::easing::quinticInOut, step, fallback);
                case 16: return runTweenyBuilder(tweeny::easing::exponentialIn, step, fallback);
                case 17: return runTweenyBuilder(tweeny::easing::exponentialOut, step, fallback);
                case 18: return runTweenyBuilder(tweeny::easing::exponentialInOut, step, fallback);
                case 19: return runTweenyBuilder(tweeny::easing::circularIn, step, fallback);
                case 20: return runTweenyBuilder(tweeny::easing::circularOut, step, fallback);
                case 21: return runTweenyBuilder(tweeny::easing::circularInOut, step, fallback);
                case 22: return runTweenyBuilder(tweeny::easing::backIn, step, fallback);
                case 23: return runTweenyBuilder(tweeny::easing::backOut, step, fallback);
                case 24: return runTweenyBuilder(tweeny::easing::backInOut, step, fallback);
                case 25: return runTweenyBuilder(tweeny::easing::elasticIn, step, fallback);
                case 26: return runTweenyBuilder(tweeny::easing::elasticOut, step, fallback);
                case 27: return runTweenyBuilder(tweeny::easing::elasticInOut, step, fallback);
                case 28: return runTweenyBuilder(tweeny::easing::bounceIn, step, fallback);
                case 29: return runTweenyBuilder(tweeny::easing::bounceOut, step, fallback);
                case 30: return runTweenyBuilder(tweeny::easing::bounceInOut, step, fallback);
                default: return runTweenyBuilder(tweeny::easing::linear, step, fallback);
            }
#else
            return fallback;
#endif
        }

        static TweenedNodeState evaluateNodeTransition(
                const SuperContainer& node,
                double globalProgress
        ) {
            TweenedNodeState state;
            if (node.decoration.has_value()) {
                state.opacity = node.decoration->opacity;
            }
            if (node.transform.has_value()) {
                state.transform = node.transform.value();
                state.hasTransform = true;
            }

            if (!node.transition.has_value()) return state;
            const TransitionProps& tr = node.transition.value();

            if (globalProgress >= 0.999 && !tr.yoyo) return state;

            // 🔥 Staggered Animation Support using delayMs & durationMs!
            double localT = globalProgress;
            if (tr.delayMs > 0 && tr.durationMs > 0) {
                double totalMs = static_cast<double>(tr.delayMs + tr.durationMs);
                double delayRatio = static_cast<double>(tr.delayMs) / totalMs;
                if (globalProgress <= delayRatio) {
                    localT = 0.0;
                } else {
                    localT = (globalProgress - delayRatio) / std::max(0.001, 1.0 - delayRatio);
                }
            }

            if (tr.yoyo) {
                localT = (localT < 0.5)
                         ? (localT * 2.0)
                         : ((1.0 - localT) * 2.0);
            }

            double eased = evaluateCurve(tr.timingFunction, localT);

            if (tr.fromOpacity.has_value()) {
                double startOp = tr.fromOpacity.value();
                state.opacity = std::clamp(startOp + (state.opacity - startOp) * eased, 0.0, 1.0);
            }
            if (tr.fromScale.has_value()) {
                double s0 = tr.fromScale.value();
                state.transform.scaleX = s0 + (state.transform.scaleX - s0) * eased;
                state.transform.scaleY = s0 + (state.transform.scaleY - s0) * eased;
                state.hasTransform = true;
            }
            if (tr.fromX.has_value()) {
                double x0 = tr.fromX.value();
                state.transform.translateX = x0 + (state.transform.translateX - x0) * eased;
                state.hasTransform = true;
            }
            if (tr.fromY.has_value()) {
                double y0 = tr.fromY.value();
                state.transform.translateY = y0 + (state.transform.translateY - y0) * eased;
                state.hasTransform = true;
            }
            if (tr.fromRotate.has_value()) {
                double r0 = tr.fromRotate.value();
                state.transform.rotateZ = r0 + (state.transform.rotateZ - r0) * eased;
                state.hasTransform = true;
            }

            return state;
        }

        // ============================================================================
        // [SECTION B] RLOTTIE VECTOR ANIMATION RASTERIZER (With speed & loop support!)
        // ============================================================================
        static ImageBuffer renderLottieFrame(
                const std::string& lottieJson,
                int width,
                int height,
                const std::optional<LottieProps>& props,
                double animProgress = 0.0
        ) {
            ImageBuffer img;
            if (lottieJson.empty() || width <= 0 || height <= 0) return img;

#if HAS_RLOTTIE_LIB
            std::unique_ptr<rlottie::Animation> animation =
                    rlottie::Animation::loadFromData(lottieJson, "", "", false);
            if (!animation) return img;

            size_t totalFrames = animation->totalFrame();
            if (totalFrames == 0) totalFrames = 1;

            size_t startFrame = 0;
            size_t endFrame = totalFrames - 1;
            double speed = 1.0;
            bool loop = true;

            if (props.has_value()) {
                startFrame = std::clamp<size_t>(props->initialFrame, 0, totalFrames - 1);
                if (props->endFrame.has_value()) {
                    endFrame = std::clamp<size_t>(props->endFrame.value(), startFrame, totalFrames - 1);
                }
                speed = std::max(0.1, props->speed);
                loop = props->loop;
            }

            size_t targetFrame = startFrame;
            if (animProgress > 0.0 && endFrame > startFrame) {
                double scaledProg = animProgress * speed;
                if (loop && scaledProg > 1.0) {
                    scaledProg = std::fmod(scaledProg, 1.0);
                }
                double p = std::clamp(scaledProg, 0.0, 1.0);
                targetFrame = startFrame + static_cast<size_t>(std::round(p * (endFrame - startFrame)));
            }

            img = ImageBuffer::allocate(width, height);
            if (!img.pixels) return img;

            std::vector<uint32_t> bgraBuf(width * height, 0);
            rlottie::Surface surface(bgraBuf.data(), width, height, width * 4);
            animation->renderSync(targetFrame, surface);

            for (int i = 0; i < width * height; ++i) {
                uint32_t px = bgraBuf[i];
                uint8_t a = (px >> 24) & 0xFF;
                uint8_t r = (px >> 16) & 0xFF;
                uint8_t g = (px >> 8) & 0xFF;
                uint8_t b = px & 0xFF;

                if (a > 0 && a < 255) {
                    r = static_cast<uint8_t>(std::min(255, (r * 255) / a));
                    g = static_cast<uint8_t>(std::min(255, (g * 255) / a));
                    b = static_cast<uint8_t>(std::min(255, (b * 255) / a));
                }

                img.pixels[i * 4 + 0] = r;
                img.pixels[i * 4 + 1] = g;
                img.pixels[i * 4 + 2] = b;
                img.pixels[i * 4 + 3] = a;
            }
#else
            (void)props;
            (void)animProgress;
#endif
            return img;
        }

        static bool hasAnimatedNodes(const SuperContainer& node) {
            if (node.type == 4 || node.transition.has_value()) return true;
            for (const auto& child : node.children) {
                if (hasAnimatedNodes(child)) return true;
            }
            return false;
        }

#ifdef CANVAS_ENABLE_GIF
        class GifAnimationWriter {
        private:
            GifWriter writer{};
            int width = 0;
            int height = 0;
            uint32_t delayCs = 4;
            bool active = false;

        public:
            bool begin(const std::string& path, int w, int h, int fps = 25) {
                width = std::max(1, w);
                height = std::max(1, h);
                int safeFps = std::clamp(fps, 1, 60);
                delayCs = static_cast<uint32_t>(std::max(2, 100 / safeFps));
                active = GifBegin(&writer, path.c_str(), width, height, delayCs);
                return active;
            }

            bool writeFrame(const uint8_t* rgbaPixels) {
                if (!active || !rgbaPixels) return false;
                writer.firstFrame = true;
                return GifWriteFrame(&writer, rgbaPixels, width, height, delayCs);
            }

            bool end() {
                if (!active) return false;
                active = false;
                return GifEnd(&writer);
            }

            ~GifAnimationWriter() {
                if (active) GifEnd(&writer);
            }
        };
#endif // CANVAS_ENABLE_GIF
    };

} // namespace CoreCanvas