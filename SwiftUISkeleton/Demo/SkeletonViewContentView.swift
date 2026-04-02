//
//  SkeletonViewContentView.swift
//  SwiftUIDemos
//
//  Created by bo.liu on 2026/4/2.
//

import SwiftUI

// MARK: - 主视图（演示页）
struct SkeletonViewContentView: View {
    @State private var selectedStyleType = 0
    @State private var selectedAnimation = SkeletonAnimation.shimmer
    @State private var isLoading = true
    @State private var reloadTrigger = 0
    private let url = URL(string: "https://www.apple.com/")!
    
    // 样式类型映射
    enum StyleType: String, CaseIterable {
        case list, grid, article, profile, card, chat
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 控制栏
            VStack(spacing: 12) {
                Picker("骨架样式", selection: $selectedStyleType) {
                    ForEach(Array(StyleType.allCases.enumerated()), id: \.element) { index, style in
                        Text(style.rawValue.capitalized).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isLoading)
                
                Picker("骨架动画", selection: $selectedAnimation) {
                    Text("扫光").tag(SkeletonAnimation.shimmer)
                    Text("脉冲").tag(SkeletonAnimation.pulse)
                    Text("波浪").tag(SkeletonAnimation.wave)
                    Text("淡入淡出").tag(SkeletonAnimation.fade)
                    Text("发光").tag(SkeletonAnimation.glow)
                    Text("无").tag(SkeletonAnimation.none)
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isLoading)
            }
            .padding()
            .background(Color(.systemBackground))
            
            // WebView 与骨架图叠加
            ZStack {
                WebView(url: url, isLoading: $isLoading, reloadTrigger: reloadTrigger)
                    .ignoresSafeArea(edges: .bottom)
                
                if isLoading {
                    skeletonViewForSelectedStyle
                        .background(Color(.systemBackground))
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.2), value: isLoading)
                }
            }
        }
        .onChange(of: selectedStyleType) { _ in reloadTrigger += 1 }
        .onChange(of: selectedAnimation) { _ in reloadTrigger += 1 }
    }
    
    @ViewBuilder
    var skeletonViewForSelectedStyle: some View {
        switch StyleType.allCases[selectedStyleType] {
        case .list:
            SkeletonView(style: SkeletonStyle.List(), animation: selectedAnimation)
        case .grid:
            SkeletonView(style: SkeletonStyle.Grid(), animation: selectedAnimation)
        case .article:
            SkeletonView(style: SkeletonStyle.Article(), animation: selectedAnimation)
        case .profile:
            SkeletonView(style: SkeletonStyle.Profile(), animation: selectedAnimation)
        case .card:
            SkeletonView(style: SkeletonStyle.Card(), animation: selectedAnimation)
        case .chat:
            SkeletonView(style: SkeletonStyle.Chat(), animation: selectedAnimation)
        }
    }
}

// MARK: - 预览
struct SkeletonViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonViewContentView()
    }
}
