//
//  TimelineRow.swift
//  Fixe
//
//  Created by MRN7BAN on 19/10/25.
//

import SwiftUI

struct TimelineRow: View {
    var stage: ServiceStage
    var isLast: Bool

    var body: some View {
        HStack(alignment: .top) {
            // Left Timeline with Dot/Line
            VStack {
                Circle()
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .fill(stage.isCompleted ? Color.hcBlue : .white)
                            .stroke(Color.hcBlue, lineWidth: 2)
                    )
                if !isLast {
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(Color.hcBlue.opacity(0.4))
                        .padding(.top, -2)
                }
            }

            // Right Content
            VStack(alignment: .leading, spacing: 4) {
                Text(stage.date)
                    .font(.caption)
                    .foregroundColor(Color.hcBlue)
                Text(stage.title)
                    .font(.headline)
                    .foregroundStyle(Color.hcTextPrimary)
                if let subtitle = stage.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color.hcTextSecondary)
                }
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 0) {
        TimelineRow(
            stage: ServiceStage(
                date: "21/07/2023 09:40",
                title: "Case Registered",
                subtitle: "Issue - Beeping Sound",
                isCompleted: true
            ),
            isLast: false
        )
        
        TimelineRow(
            stage: ServiceStage(
                date: "22/07/2023 10:40",
                title: "Engineer Assigned",
                subtitle: "Mohan Singh",
                isCompleted: true
            ),
            isLast: false
        )
        
        TimelineRow(
            stage: ServiceStage(
                date: "22/07/2023 10:40",
                title: "Engineer Assigned",
                subtitle: "Mohan Singh",
                isCompleted: false
            ),
            isLast: true
            )
    }
    .padding()
}
