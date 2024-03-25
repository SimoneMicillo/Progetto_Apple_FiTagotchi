//
//  AppIntent.swift
//  ExpressionWidgetExtension
//
//  Created by Alessandro on 05/03/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Fitagotchi"
    static var description = IntentDescription("FiTagotchi's actual emotion.")
    
    @Parameter(title: "CompletionPercentage", default: 0.0)
    var completionPercentage: Double
}
