//
//  SearchResultRow.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import SwiftUI

struct SearchResultRow: View {
    let item: SearchResultItem
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: item.imageUrl)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.category.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(resultTypeIcon(for: item.type))
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(resultTypeColor(for: item.type).opacity(0.2))
                        .foregroundColor(resultTypeColor(for: item.type))
                        .clipShape(Capsule())
                }
                
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
    
    import SwiftUI

    struct SearchResultRow: View {
        let item: SearchResultItem
        
        var body: some View {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.category.uppercased())
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text(resultTypeIcon(for: item.type))
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(resultTypeColor(for: item.type).opacity(0.2))
                            .foregroundColor(resultTypeColor(for: item.type))
                            .clipShape(Capsule())
                    }
                    
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 8)
        }
        
        private func resultTypeIcon(for type: SearchResultType) -> String {
            switch type {
            case .article:
                return "📝"
            case .video:
                return "🎬"
            case .podcast:
                return "🎙️"
            case .event:
                return "📅"
            case .profile:
                return "👤"
            case .unknown:
                return "📄"
            }
        }
        
        private func resultTypeColor(for type: SearchResultType) -> Color {
            switch type {
            case .article:
                return .blue
            case .video:
                return .red
            case .podcast:
                return .purple
            case .event:
                return .green
            case .profile:
                return .orange
            case .unknown:
                return .gray
            }
        }
    }
