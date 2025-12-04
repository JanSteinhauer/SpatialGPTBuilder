//
//  SpatialGPTWidget.swift
//  SpatialGPTWidget
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import WidgetKit
import SwiftUI

enum LLMFlavor { case security, finance }

// MARK: - View Model

struct LLMInfo: Hashable {
    let id: UUID = .init()
    let title: String
    let logoName: String
    let overviewHeader: String
    let overviewBullets: [String]
    let securityHeader: String
    let securityBullets: [String]
    let footer: String

    static func forChoice(_ choice: LLMChoice, flavor: LLMFlavor) -> LLMInfo {
        switch (choice, flavor) {

        case (.chatgpt, .security):
            return LLMInfo(
                title: "ChatGPT",
                logoName: "ChatGPT",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Widely used",
                    "Based on US infrastructure"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Data processing occurs outside the EU"
                ],
                footer: "ChatGPT is an AI chatbot that understands and generates human-like text."
            )

        case (.chatgpt, .finance):
            return LLMInfo(
                title: "ChatGPT",
                logoName: "ChatGPT",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Widely used",
                    "Based on US infrastructure"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "High API costs",
                    "$0.01–$0.06 per 1,000 tokens",
                    "High costs for continuous use"
                ],
                footer: "ChatGPT is an AI chatbot that understands and generates human-like text."
            )

        case (.anthropic, .security):
            return LLMInfo(
                title: "Claude",
                logoName: "Anthropic",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Very secure",
                    "Produces reliable statements"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "High",
                    "Withholds sensitive data",
                    "GDPR-friendly"
                ],
                footer: "Claude is an AI chatbot that understands and generates human-like text."
            )

        case (.anthropic, .finance):
            return LLMInfo(
                title: "Claude",
                logoName: "Anthropic",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Very secure",
                    "Produces reliable statements"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium",
                    "$0.005–$0.03 per 1,000 tokens"
                ],
                footer: "Claude is an AI chatbot that understands and generates human-like text."
            )
            
        case (.gemini, .security):
            return LLMInfo(
                title: "Gemini",
                logoName: "Gemini",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrated into the Google ecosystem",
                    "Strong at multimodal input",
                    "Can generate images"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Google Cloud security standards",
                    "Hosting in the USA"
                ],
                footer: "Gemini is an AI chatbot that understands and generates human-like text."
            )

        case (.gemini, .finance):
            return LLMInfo(
                title: "Gemini",
                logoName: "Gemini",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrated into the Google ecosystem",
                    "Strong at multimodal input",
                    "Can generate images"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Low",
                    "$0.002–$0.01 per 1,000 tokens",
                    "Useful if you are a Google customer"
                ],
                footer: "Gemini is an AI chatbot that understands and generates human-like text."
            )
            
        case (.llama, .security):
                    return LLMInfo(
                        title: "Llama",
                        logoName: "Llama",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Powerful open-source LLM",
                            "Runs locally or in a private cloud",
                            "Flexible deployment and tuning"
                        ],
                        securityHeader: "Security Overview",
                        securityBullets: [
                            "High",
                            "Full data control when self-hosted",
                            "No third-party data processing by default"
                        ],
                        footer: "Llama is an open-source family of models that can be deployed on your own infrastructure."
                    )

                case (.llama, .finance):
                    return LLMInfo(
                        title: "Llama",
                        logoName: "Llama",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Powerful open-source LLM",
                            "Runs locally or in a private cloud",
                            "Flexible deployment and tuning"
                        ],
                        securityHeader: "Financial Overview",
                        securityBullets: [
                            "Medium",
                            "No ongoing API fees; own hardware needed",
                            "Performance and cost depend on your hardware"
                        ],
                        footer: "Llama is an open-source family of models that can be deployed on your own infrastructure."
                    )

                case (.gemma, .security):
                    return LLMInfo(
                        title: "Gemma",
                        logoName: "Gemma",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Lightweight model from Google",
                            "Can run locally or in a private cloud",
                            "Integrates well with Google Cloud"
                        ],
                        securityHeader: "Security Overview",
                        securityBullets: [
                            "High",
                            "No data sent to Google when self-hosted",
                            "Full control over data flows"
                        ],
                        footer: "Gemma is a lightweight model designed for efficient local or private-cloud deployments."
                    )

                case (.gemma, .finance):
                    return LLMInfo(
                        title: "Gemma",
                        logoName: "Gemma",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Lightweight model from Google",
                            "Can run locally or in a private cloud",
                            "Integrates well with Google Cloud"
                        ],
                        securityHeader: "Financial Overview",
                        securityBullets: [
                            "Medium",
                            "Lower quality than Gemini but cost-efficient"
                        ],
                        footer: "Gemma is designed for efficient local or private-cloud deployments."
                    )
            
        case (.standaloneWebApp, .security):
            return LLMInfo(
                title: "Web App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Separate platform",
                    "Easy browser access",
                    "No installation required"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Few attack surfaces but limited control",
                    "Hard to embed data from other tools"
                ],
                footer: "A standalone web app runs in the browser and needs no local setup."
            )

        case (.standaloneWebApp, .finance):
            return LLMInfo(
                title: "Web App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Separate platform",
                    "Easy browser access",
                    "No installation required"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Low cost",
                    "Quick to deploy",
                    "Minimal setup"
                ],
                footer: "Inexpensive and fast to launch from any browser."
            )

        // --- API Integration ---
        case (.apiIntegration, .security):
            return LLMInfo(
                title: "API",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrates into existing tools",
                    "Seamless daily workflow",
                    "Requires integration effort"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Depends on API access control",
                    "Interfaces can introduce vulnerabilities"
                ],
                footer: "Connects AI directly into enterprise tools via APIs."
            )

        case (.apiIntegration, .finance):
            return LLMInfo(
                title: "API",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrates into existing tools",
                    "Seamless daily workflow",
                    "Requires integration effort"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium",
                    "Implementation adds some cost",
                    "Long-term efficiency benefits"
                ],
                footer: "Requires dev work but streamlines workflows."
            )

        case (.mobileApp, .security):
            return LLMInfo(
                title: "Mobile App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Mobile or intranet availability",
                    "High user convenience",
                    "Accessible from anywhere"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Low",
                    "Endpoint usage increases risk",
                    "More device-based vulnerabilities"
                ],
                footer: "Flexible but comes with higher endpoint security risks."
            )

        case (.mobileApp, .finance):
            return LLMInfo(
                title: "Mobile App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Mobile or intranet availability",
                    "High user convenience",
                    "Accessible from anywhere"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium",
                    "Moderate setup & maintenance",
                    "Convenience boosts productivity"
                ],
                footer: "Cost-efficient and very convenient for daily use."
            )
            
        case (.freeUse, .security):
            return LLMInfo(
                title: "Free Use",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "All users can use the application fully",
                    "Very high flexibility for end users",
                    "Fast adoption with minimal friction"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Low",
                    "Risk of data misuse or unauthorized access",
                ],
                footer: "Free Use maximizes accessibility but requires strong data boundaries elsewhere."
            )

        case (.freeUse, .finance):
            return LLMInfo(
                title: "Free Use",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "All users can use the application fully",
                    "Very high flexibility for end users",
                    "Fast adoption with minimal friction"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Very low (near zero) cost",
                    "No moderation overhead",
                ],
                footer: "Lowest-cost rollout, trading off governance for speed and convenience."
            )

        case (.moderationFilter, .security):
            return LLMInfo(
                title: "Moderation",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Inputs and outputs checked for sensitive data",
                    "Prevents undesired information leakage",
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Blocks many risky cases",
                    "Filters are not perfect and can be bypassed"
                ],
                footer: "Moderation provides a balanced control layer without fully restricting access."
            )

        case (.moderationFilter, .finance):
            return LLMInfo(
                title: "Moderation",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Inputs and outputs checked for sensitive data",
                    "Prevents undesired information leakage",
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Low to medium cost",
                    "Operational overhead for review/maintenance",
                    "Reasonable ongoing effort"
                ],
                footer: "Moderation costs are modest compared to the governance benefits."
            )

        case (.roleBasedAccess, .security):
            return LLMInfo(
                title: "Role Access",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Access rights assigned by roles/departments",
                    "Least-privilege by design",
                    "Granular policy control"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "High",
                    "Company controls and steers data flows",
                    "Strong guardrails and auditability"
                ],
                footer: "Role-based access maximizes control and compliance through defined permissions."
            )

        case (.roleBasedAccess, .finance):
            return LLMInfo(
                title: "Role Access",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Access rights assigned by roles/departments",
                    "Least-privilege by design",
                    "Granular policy control"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium cost",
                    "High administrative overhead (complex management)",
                    "May limit user flexibility and adoption"
                ],
                footer: "Higher admin effort in exchange for strong governance and compliance."
            )
            
            case (.localServer, .security):
                return LLMInfo(
                    title: "Local Server",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Runs on your own servers inside the corporate network",
                        "Only available for certain self-hostable AI models; otherwise grayed out",
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Very High",
                        "Full control over data and access",
                        "No dependency on external vendors"
                    ],
                    footer: "Choose Local Server when strict data residency and full control are mandatory."
                )

            case (.localServer, .finance):
                return LLMInfo(
                    title: "Local Server",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Runs on your own servers inside the corporate network",
                        "Only available for certain self-hostable AI models; otherwise grayed out",
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Very High",
                        "Significant personnel, energy, and hardware costs",
                    ],
                    footer: "Expect high upfront and ongoing costs due to hardware and operations."
                )

            case (.privateCloud, .security):
                return LLMInfo(
                    title: "Private Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Dedicated cloud environment implemented for your company",
                        "Provided/managed by an external vendor",
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Medium",
                        "Improved data control and policy alignment",
                        "Still dependent on an external provider’s infrastructure"
                    ],
                    footer: "Private Cloud balances control with managed operations."
                )

            case (.privateCloud, .finance):
                return LLMInfo(
                    title: "Private Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Dedicated cloud environment implemented for your company",
                        "Provided/managed by an external vendor",
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "High",
                        "Ongoing maintenance costs",
                        "More expensive than public cloud"
                    ],
                    footer: "Higher TCO than public cloud due to dedicated environments and SLAs."
                )

            case (.cloud, .security):
                return LLMInfo(
                    title: "Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "No own hardware needed",
                        "Everything runs via public APIs (e.g., OpenAI API)",
                        "Fastest to start and scale"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Very Low",
                        "Data leaves the company (depends on chosen AI model and vendor)",
                        "Strong contractual and technical safeguards required"
                    ],
                    footer: "Public cloud offers speed and scale but shifts control to the provider."
                )

            case (.cloud, .finance):
                return LLMInfo(
                    title: "Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "No own hardware needed",
                        "Everything runs via public APIs (e.g., OpenAI API)",
                        "Fastest to start and scale"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Low to Medium",
                        "Pay-as-you-go; no hardware purchases",
                        "Costs scale with usage"
                    ],
                    footer: "Operational expenditure model with quick time-to-value."
                )
            
            case (.standardEncryption, .security):
                return LLMInfo(
                    title: "Standard",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Password-based protection",
                        "Quick and easy to implement",
                        "Baseline security for small teams"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Low",
                        "Not fully GDPR-compliant in many setups",
                        "Higher risk of compromise"
                    ],
                    footer: "Standard encryption is fast to deploy but offers limited protection and compliance."
                )

            case (.standardEncryption, .finance):
                return LLMInfo(
                    title: "Standard",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Password-based protection",
                        "Quick and easy to implement",
                        "Baseline security for small teams"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Low cost",
                        "Minimal operational overhead",
                        "Few administrative requirements"
                    ],
                    footer: "Lowest-cost option with basic protection only."
                )

            case (.multiFactorAuth, .security):
                return LLMInfo(
                    title: "Multi-Factor",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Users authenticate with password plus a second factor",
                        "Second factor via authenticator app or SMS",
                        "Significantly strengthens account security"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Very High",
                        "Maximum hardening against account takeover",
                        "Strong compliance posture"
                    ],
                    footer: "MFA delivers strong protection."
                )

            case (.multiFactorAuth, .finance):
                return LLMInfo(
                    title: "Multi-Factor",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Users authenticate with password plus a second factor",
                        "Second factor via authenticator app or SMS",
                        "Significantly strengthens account security"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Very High cost",
                        "Licensing and rollout costs",
                        "Ongoing support and user training"
                    ],
                    footer: "Higher costs due to licensing, rollout, and helpdesk load."
                )

            case (.privacyByDesign, .security):
                return LLMInfo(
                    title: "Privacy by Design",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "No data is stored (anonymous usage)",
                        "No history access limits some use cases",
                        "Strong privacy defaults from the start"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Very High",
                        "Personal data is deleted immediately",
                    ],
                    footer: "Maximizes privacy and compliance, at the expense of historical analytics."
                )

            case (.privacyByDesign, .finance):
                return LLMInfo(
                    title: "Privacy by Design",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "No data is stored (anonymous usage)",
                        "No history access limits some use cases",
                        "Strong privacy defaults from the start"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Medium to High",
                        "Cost depends on access model and controls"
                    ],
                    footer: "Trade-offs: higher privacy, fewer analytic possibilities, variable costs."
                )
            
            
            case (.microsoft365, .security):
                return LLMInfo(
                    title: "Microsoft",
                    logoName: "Microsoft",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Integrates with Teams and Outlook",
                        "Access to documents in SharePoint",
                        "Fits existing Microsoft workflows"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "High",
                        "GDPR-compliant if hosted in DE/EU",
                        "Mature enterprise controls"
                    ],
                    footer: "Use Microsoft 365 to leverage existing MS ecosystem."
                )

            case (.microsoft365, .finance):
                return LLMInfo(
                    title: "Microsoft",
                    logoName: "Microsoft",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Integrates with Teams and Outlook",
                        "Access to documents in SharePoint",
                        "Fits existing Microsoft workflows"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Medium",
                        "License costs (≈ $12.50 per user)",
                        "Scope limited to MS-stored data"
                    ],
                    footer: "Data scope is bounded by Microsoft storage."
                )

            case (.googleWorkspace, .security):
                return LLMInfo(
                    title: "Google",
                    logoName: "Google",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Connects to Gmail and Google Drive",
                        "Strong collaboration features",
                        "Well-suited for Google-first orgs"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Medium",
                        "Good technical security",
                        "US-based hosting and regulations"
                    ],
                    footer: "Solid security posture, but consider data residency and compliance."
                )

            case (.googleWorkspace, .finance):
                return LLMInfo(
                    title: "Google",
                    logoName: "Google",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Connects to Gmail and Google Drive",
                        "Strong collaboration features",
                        "Well-suited for Google-first orgs"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Low to Medium",
                        "Licensing applies",
                        "Scope limited to Google-stored data"
                    ],
                    footer: "Cost-effective if already standardized on Google Workspace."
                )

            case (.internalSystems, .security):
                return LLMInfo(
                    title: "Internal",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Connects to company-internal databases",
                        "Maximizes enterprise data coverage"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "High",
                        "Internally hosted data for maximum control",
                        "Best for sensitive information"
                    ],
                    footer: "Ideal when strict data control is required."
                )

            case (.internalSystems, .finance):
                return LLMInfo(
                    title: "Internal",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Connects to company-internal databases",
                        "Custom integrations for line-of-business data",
                        "Maximizes enterprise data coverage"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "High",
                        "Integration and maintenance effort",
                        "Search limited to internal sources"
                    ],
                    footer: "Expect higher TCO due to integration and ongoing maintenance."
                )

            case (.openData, .security):
                return LLMInfo(
                    title: "Open Data",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Uses freely available web content",
                        "Broad external information coverage",
                        "Similar to public web grounding"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Low",
                        "No control over data origin or quality",
                        "Risk of misinformation"
                    ],
                    footer: "Great reach, but requires validation and careful governance."
                )

            case (.openData, .finance):
                return LLMInfo(
                    title: "Open Data",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Uses freely available web content",
                        "Broad external information coverage",
                        "Similar to public web grounding"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Very Low",
                        "Data is freely available",
                        "Minimal direct costs"
                    ],
                    footer: "Lowest cost, but added effort to ensure reliability."
                )

            case (.germanyHosting, .security):
                return LLMInfo(
                    title: "Germany",
                    logoName: "Germany",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosted exclusively in German data centers",
                        "Must comply with strict GDPR and national standards",
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Very High",
                        "Maximum privacy and data protection",
                        "Clear local regulatory framework"
                    ],
                    footer: "Germany hosting provides the strongest data privacy."
                )

            case (.germanyHosting, .finance):
                return LLMInfo(
                    title: "Germany",
                    logoName: "Germany",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosted exclusively in German data centers",
                        "Must comply with strict GDPR and national standards",
                        "Strong data residency guarantees"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Medium",
                        "Potential premium for in-country hosting",
                        "Limited provider flexibility compared to global options"
                    ],
                    footer: "Expect moderate cost."
                )

            case (.euHosting, .security):
                return LLMInfo(
                    title: "Europe",
                    logoName: "EU",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosted across EU data centers",
                        "Generally GDPR-compliant",
                        "National standards vary by member state"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "High",
                        "Strong legal basis across the EU",
                        "Variations in national implementations"
                    ],
                    footer: "EU hosting balances compliance with broader infrastructure choice."
                )

            case (.euHosting, .finance):
                return LLMInfo(
                    title: "Europe",
                    logoName: "EU",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosted across EU data centers",
                        "Generally GDPR-compliant",
                        "National standards vary by member state"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Medium",
                        "Competitive pricing among EU providers",
                        "Costs depend on country and SLAs"
                    ],
                    footer: "Typical EU pricing with good compliance coverage."
                )

            case (.globalHosting, .security):
                return LLMInfo(
                    title: "Worldwide",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Global data centers for higher availability",
                        "Useful for multi-region performance"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Lower privacy protections in some regions",
                        "Heightened risk without strong contractual controls"
                    ],
                    footer: "Global hosting maximizes reach but weakens data residency guarantees."
                )

            case (.globalHosting, .finance):
                return LLMInfo(
                    title: "Worldwide",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Global data centers for higher availability",
                        "Broad provider and region choice",
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "High",
                        "Fewer providers meet high standards in all regions",
                        "Premium pricing for globally compliant setups"
                    ],
                    footer: "Expect higher cost."
                )
            
            case (.internalStorage, .security):
                return LLMInfo(
                    title: "Internal Storage",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Model reads from a predefined company database",
                        "Database updates are manual (no live data access)",
                        "Potential limitations due to stale content"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Medium to High",
                        "Risk depends on the chosen AI model",
                    ],
                    footer: "Internal Storage favors cost control but requires strict update procedures."
                )

            case (.internalStorage, .finance):
                return LLMInfo(
                    title: "Internal Storage",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Model reads from a predefined company database",
                        "Database updates are manual (no live data access)",
                        "Potential limitations due to stale content"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Low to Medium",
                        "No live-data query costs",
                        "Pay for database storage plus maintenance"
                    ],
                    footer: "Cheaper than live pipelines; maintenance effort remains."
                )

            case (.fineTuning, .security):
                return LLMInfo(
                    title: "Fine-Tuning",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Model is further trained on internal company data",
                        "Delivers highly company-specific answers",
                        "Strong performance if training data is curated"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Low",
                        "Risk profile depends on the AI model and vendor"
                    ],
                    footer: "Great alignment with company needs; ensure secure training workflows."
                )

            case (.fineTuning, .finance):
                return LLMInfo(
                    title: "Fine-Tuning",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Model is further trained on internal company data",
                        "Delivers highly company-specific answers",
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "High",
                        "Data preparation and training are costly",
                        "Best performance, but highest upfront spend"
                    ],
                    footer: "Expect significant costs for data prep, training, and validation."
                )

            case (.rag, .security):
                return LLMInfo(
                    title: "RAG",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Like Internal Storage, but queries firm knowledge on every request",
                        "Quality depends on indexing and document hygiene"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Depends on data sources and AI model",
                        "Access control and logging are critical",
                    ],
                    footer: "RAG improves freshness and context at the cost of pipeline complexity."
                )

            case (.rag, .finance):
                return LLMInfo(
                    title: "RAG",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Like Internal Storage, but queries firm knowledge on every request",
                        "Combines retrieval with generation for fresher answers",
                        "Quality depends on indexing and document hygiene"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Medium",
                        "Better data quality → better performance → higher cost"
                    ],
                    footer: "Ongoing cost scales with corpus size, refresh rate, and infra."
                )


        }
    }
}

// MARK: - Timeline Entries

struct LLMEntry: TimelineEntry {
    let date: Date
    let config: LLMConfigurationIntent
    let info: LLMInfo
}

// MARK: - Providers (one per flavor)

struct SecurityLLMProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLMEntry {
        LLMEntry(date: .now,
                 config: LLMConfigurationIntent(),
                 info: .forChoice(.chatgpt, flavor: .security))
    }

    func snapshot(for configuration: LLMConfigurationIntent, in context: Context) async -> LLMEntry {
        LLMEntry(date: .now,
                 config: configuration,
                 info: .forChoice(configuration.provider, flavor: .security))
    }

    func timeline(for configuration: LLMConfigurationIntent, in context: Context) async -> Timeline<LLMEntry> {
        let start = Date()
        let entries = (0..<5).map { h in
            LLMEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!,
                     config: configuration,
                     info: .forChoice(configuration.provider, flavor: .security))
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct FinanceLLMProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLMEntry {
        LLMEntry(date: .now,
                 config: LLMConfigurationIntent(),
                 info: .forChoice(.chatgpt, flavor: .finance))
    }

    func snapshot(for configuration: LLMConfigurationIntent, in context: Context) async -> LLMEntry {
        LLMEntry(date: .now,
                 config: configuration,
                 info: .forChoice(configuration.provider, flavor: .finance))
    }

    func timeline(for configuration: LLMConfigurationIntent, in context: Context) async -> Timeline<LLMEntry> {
        let start = Date()
        let entries = (0..<5).map { h in
            LLMEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!,
                     config: configuration,
                     info: .forChoice(configuration.provider, flavor: .finance))
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

// MARK: - Views

struct LLMCardView: View {
    let info: LLMInfo
    @Environment(\.levelOfDetail) private var lod

    private var isTitleOnly: Bool { info.logoName == "titel" }
    
    private var titleFontSize: CGFloat { info.title.count > 8 ? 25 : 30 }


        var body: some View {
            switch lod {
            case .simplified: simplifiedView
            default: detailedView
            }
        }

        private var simplifiedView: some View {
            Group {
                if isTitleOnly {
                    Text(info.title)
                        .font(.system(size: titleFontSize, weight: .bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .accessibilityLabel("\(info.title) widget")
                } else {
                    VStack(spacing: 8) {
                        Image(info.logoName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60, maxHeight: 60)
                            .accessibilityHidden(true)
                        Text(info.title)
                            .font(.system(size: titleFontSize, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .accessibilityLabel("\(info.title) widget")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
        }

        private var detailedView: some View {
            VStack(alignment: .leading, spacing: 2) {
                Spacer(minLength: 0)

                HStack(alignment: .center, spacing: 10) {
                    if !isTitleOnly {
                        Image(info.logoName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .accessibilityHidden(true)
                    }
                    Text(info.title)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Divider()
                SectionHeader(title: info.overviewHeader)
                BulletList(items: info.overviewBullets)

                Divider()
                SectionHeader(title: info.securityHeader)
                BulletList(items: info.securityBullets)

                Divider()
                Text(info.footer)
                    .font(.system(size: 7))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .minimumScaleFactor(0.9)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 9))
            .fontWeight(.semibold)
            .textCase(.none)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct BulletList: View {
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("•").accessibilityHidden(true)
                    Text(items[i]).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .font(.system(size: 7))
        .padding(.top, 0)
    }
}

// MARK: - Widgets (exactly two)

struct SecurityLLMWidget: Widget {
    let kind = "SecurityLLMWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: LLMConfigurationIntent.self,
                               provider: SecurityLLMProvider()) { entry in
            LLMCardView(info: entry.info)
                .containerBackground(.white.gradient, for: .widget)
        }
        .configurationDisplayName("LLM – Security")
        .description("Security overview for ChatGPT, Claude, or Gemini.")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}

struct FinanceLLMWidget: Widget {
    let kind = "FinanceLLMWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: LLMConfigurationIntent.self,
                               provider: FinanceLLMProvider()) { entry in
            LLMCardView(info: entry.info)
                .containerBackground(.white.gradient, for: .widget)
        }
        .configurationDisplayName("LLM – Finance")
        .description("Financial overview for ChatGPT, Claude, or Gemini.")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
