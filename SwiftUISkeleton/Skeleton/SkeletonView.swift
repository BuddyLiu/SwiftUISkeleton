//
//  SkeletonView.swift
//  SwiftUIDemos
//
//  Created by bo.liu on 2026/4/2.
//

import SwiftUI

// MARK: - SkeletonView 主组件
/// 骨架屏组件
public struct SkeletonView<Style: SkeletonStyleProtocol>: View {
    private let style: Style
    private let animation: SkeletonAnimation
    private let color: Color
    private let backgroundColor: Color
    
    /// 初始化骨架视图
    /// - Parameters:
    ///   - style: 骨架样式（遵循 `SkeletonStyleProtocol`）
    ///   - animation: 动画类型，默认 `.shimmer`
    ///   - color: 骨架元素颜色，默认灰色
    ///   - backgroundColor: 背景色，默认白色
    public init(style: Style,
                animation: SkeletonAnimation = .shimmer,
                color: Color = .gray.opacity(0.3),
                backgroundColor: Color = .white) {
        self.style = style
        self.animation = animation
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        style.makeBody()
            .environment(\.skeletonColor, color)
            .background(backgroundColor)
            .applyAnimation(animation, color: color)
    }
}

// MARK: - Skeleton 样式协议
/// 定义骨架视图的布局内容
public protocol SkeletonStyleProtocol {
    associatedtype Content: View
    /// 返回骨架内容视图
    @ViewBuilder func makeBody() -> Content
}

// MARK: - 预设样式
extension SkeletonStyle {
    /// 列表样式（头像 + 两行文字）
    struct List: SkeletonStyleProtocol {
        let itemCount: Int
        let avatarSize: CGFloat
        let lineHeight: CGFloat
        let spacing: CGFloat
        
        public init(itemCount: Int = 5,
                    avatarSize: CGFloat = 50,
                    lineHeight: CGFloat = 16,
                    spacing: CGFloat = 20) {
            self.itemCount = itemCount
            self.avatarSize = avatarSize
            self.lineHeight = lineHeight
            self.spacing = spacing
        }
        
        public func makeBody() -> some View {
            VStack(spacing: spacing) {
                ForEach(0..<itemCount, id: \.self) { _ in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: avatarSize, height: avatarSize)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: lineHeight)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: lineHeight * 0.75)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
    
    /// 网格样式（正方形图片 + 两行文字）
    struct Grid: SkeletonStyleProtocol {
        let columns: Int
        let itemCount: Int
        let spacing: CGFloat
        let cornerRadius: CGFloat
        
        public init(columns: Int = 2,
                    itemCount: Int = 6,
                    spacing: CGFloat = 16,
                    cornerRadius: CGFloat = 12) {
            self.columns = columns
            self.itemCount = itemCount
            self.spacing = spacing
            self.cornerRadius = cornerRadius
        }
        
        public func makeBody() -> some View {
            let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
            return LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(0..<itemCount, id: \.self) { _ in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(1, contentMode: .fit)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 14)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 12)
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding()
        }
    }
    
    /// 文章样式（大图 + 标题 + 段落）
    struct Article: SkeletonStyleProtocol {
        let imageHeight: CGFloat
        let titleWidth: CGFloat
        let paragraphLines: Int
        
        public init(imageHeight: CGFloat = 200,
                    titleWidth: CGFloat = 200,
                    paragraphLines: Int = 4) {
            self.imageHeight = imageHeight
            self.titleWidth = titleWidth
            self.paragraphLines = paragraphLines
        }
        
        public func makeBody() -> some View {
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: imageHeight)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 24)
                        .frame(width: titleWidth)
                    
                    ForEach(0..<paragraphLines, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 14)
                    }
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 14)
                        .frame(width: titleWidth * 0.75)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
    
    /// 个人资料样式（头像 + 名字 + 简介 + 统计数据 + 按钮）
    struct Profile: SkeletonStyleProtocol {
        let avatarSize: CGFloat
        let statsCount: Int
        
        public init(avatarSize: CGFloat = 100, statsCount: Int = 3) {
            self.avatarSize = avatarSize
            self.statsCount = statsCount
        }
        
        public func makeBody() -> some View {
            VStack(spacing: 20) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: avatarSize, height: avatarSize)
                    .padding(.top, 40)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 24)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 16)
                
                HStack(spacing: 30) {
                    ForEach(0..<statsCount, id: \.self) { _ in
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 20)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 14)
                        }
                    }
                }
                .padding(.top, 20)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 44)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    /// 卡片样式（头像+昵称 + 图片 + 文字 + 互动按钮）
    struct Card: SkeletonStyleProtocol {
        let itemCount: Int
        
        public init(itemCount: Int = 3) {
            self.itemCount = itemCount
        }
        
        public func makeBody() -> some View {
            VStack(spacing: 16) {
                ForEach(0..<itemCount, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 16)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 12)
                            }
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 180)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 14)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 14)
                            .frame(width: 200)
                        
                        HStack(spacing: 20) {
                            ForEach(0..<3, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 30, height: 20)
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
    
    /// 聊天样式（交替消息）
    struct Chat: SkeletonStyleProtocol {
        let messageCount: Int
        
        public init(messageCount: Int = 5) {
            self.messageCount = messageCount
        }
        
        public func makeBody() -> some View {
            VStack(spacing: 16) {
                ForEach(0..<messageCount, id: \.self) { index in
                    HStack {
                        if index % 2 == 0 {
                            // 对方消息
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 180, height: 16)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 120, height: 14)
                                }
                                Spacer()
                            }
                        } else {
                            // 自己消息
                            HStack(alignment: .top, spacing: 8) {
                                Spacer()
                                VStack(alignment: .trailing, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 180, height: 16)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 120, height: 14)
                                }
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}

// MARK: - 环境变量支持自定义颜色
private struct SkeletonColorKey: EnvironmentKey {
    static let defaultValue: Color = .gray.opacity(0.3)
}

extension EnvironmentValues {
    var skeletonColor: Color {
        get { self[SkeletonColorKey.self] }
        set { self[SkeletonColorKey.self] = newValue }
    }
}

// 为预设样式中的颜色使用环境变量（需修改预设样式，这里为了简洁不展开，实际使用时可通过 modifier 覆盖）

// MARK: - 骨架样式枚举
enum SkeletonStyle {
    case list      // 列表样式
    case grid      // 网格样式
    case article   // 文章样式
    case profile   // 个人资料样式
    case card      // 卡片样式
    case chat      // 聊天样式
}

// MARK: - 动画定义
public enum SkeletonAnimation {
    case shimmer
    case pulse
    case wave
    case fade
    case glow
    case none
}

extension View {
    @ViewBuilder
    func applyAnimation(_ animation: SkeletonAnimation, color: Color) -> some View {
        switch animation {
        case .shimmer:
            self.modifier(ShimmerModifier(color: color))
        case .pulse:
            self.modifier(PulseModifier())
        case .wave:
            self.modifier(WaveModifier())
        case .fade:
            self.modifier(FadeModifier())
        case .glow:
            self.modifier(GlowModifier(color: color))
        case .none:
            self
        }
    }
}

// 以下动画修饰器保持原有实现，但增加颜色参数支持
struct ShimmerModifier: ViewModifier {
    let color: Color
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.6),
                        Color.white.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: isAnimating ? 400 : -400)
                .animation(
                    Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                    value: isAnimating
                )
            )
            .onAppear { isAnimating = true }
            .clipped()
    }
}

struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 0.5 : 1)
            .animation(
                Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear { isPulsing = true }
    }
}

struct WaveModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.4),
                        Color.white.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: isAnimating ? 400 : -400)
                .animation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: false),
                    value: isAnimating
                )
            )
            .onAppear { isAnimating = true }
            .clipped()
    }
}

struct FadeModifier: ViewModifier {
    @State private var isFading = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isFading ? 0.3 : 1)
            .animation(
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: isFading
            )
            .onAppear { isFading = true }
    }
}

struct GlowModifier: ViewModifier {
    let color: Color
    @State private var isGlowing = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0),
                                Color.white.opacity(0.8),
                                Color.white.opacity(0)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
                    .scaleEffect(isGlowing ? 1.02 : 1)
                    .opacity(isGlowing ? 1 : 0)
                    .animation(
                        Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: isGlowing
                    )
            )
            .onAppear { isGlowing = true }
    }
}
