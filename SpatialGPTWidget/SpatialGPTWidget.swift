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
                    "Leistungsstarkes Modell",
                    "Standardmäßig Verarbeitung in den USA"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Mittlere Sicherheit",
                    "Geringes Ausfallrisiko durch stabile Infrastruktur"
                ],
                footer: "ChatGPT ist leistungsstark, aber sicherheitsseitig weniger EU-konform."
            )

        case (.chatgpt, .finance):
            return LLMInfo(
                title: "ChatGPT",
                logoName: "ChatGPT",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Leistungsstarkes Modell",
                    "US-basierte Infrastruktur"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Hohe API-Kosten",
                    "Sehr gute Geschwindigkeit"
                ],
                footer: "ChatGPT ist hochwertig, aber kostspielig."
            )

        case (.anthropic, .security):
            return LLMInfo(
                title: "Claude",
                logoName: "Anthropic",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Sehr sicheres Modell",
                    "Stabile und verlässliche Antworten"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Hohe Sicherheit",
                    "Sehr geringe Fehlerquote"
                ],
                footer: "Claude bietet starke Sicherheitsmechanismen."
            )

        case (.anthropic, .finance):
            return LLMInfo(
                title: "Claude",
                logoName: "Anthropic",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Sehr sicheres Modell",
                    "Verlässliche Ausgabequalität"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Mittlere Kosten",
                    "Geringe indirekte Fehlerkosten"
                ],
                footer: "Claude ist stabil und preislich moderat."
            )
            
        case (.gemini, .security):
            return LLMInfo(
                title: "Gemini",
                logoName: "Gemini",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Gut im Google-Ökosystem",
                    "Stark bei multimodalen Aufgaben"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Mittlere Sicherheit",
                    "US-Hosting kann Compliance senken"
                ],
                footer: "Gemini ist schnell, aber Daten werden außerhalb der EU gespeichert."
            )

        case (.gemini, .finance):
            return LLMInfo(
                title: "Gemini",
                logoName: "Gemini",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Multimodal stark",
                    "In Google-Dienste integriert"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Niedrige API-Kosten",
                    "Sehr hohe Geschwindigkeit"
                ],
                footer: "Gemini ist schnell und kostengünstig."
            )
            
        case (.llama, .security):
                    return LLMInfo(
                        title: "Llama",
                        logoName: "Llama",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Open-Source Modell",
                            "Volle Kontrolle durch Self-Hosting"
                        ],
                        securityHeader: "Security Overview",
                        securityBullets: [
                            "Sehr hohe Datensicherheit",
                            "Keine externen Datenflüsse"
                        ],
                        footer: "Llama bietet maximale Kontrolle."
                    )

                case (.llama, .finance):
                    return LLMInfo(
                        title: "Llama",
                        logoName: "Llama",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Open-Source Modell",
                            "Flexibel und lokal betreibbar"
                        ],
                        securityHeader: "Financial Overview",
                        securityBullets: [
                            "Sehr niedrige Laufzeitkosten",
                            "Hardware- und Betriebskosten nötig"
                        ],
                        footer: "Es ist im Betrieb sehr günstig. Es entstehen hohe Initialkosten"
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
                    "Läuft im Browser",
                    "Kein Installationsbedarf"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Mittlere Sicherheit",
                    "Begrenzte Kontrolle über Browser-Umgebung"
                ],
                footer: "Eine Web App läuft direkt im Browser ohne lokale Installation."
            )

        case (.standaloneWebApp, .finance):
            return LLMInfo(
                title: "Web App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Läuft im Browser",
                    "Schneller Zugriff ohne Installation"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Niedrige Kosten",
                    "Schnell bereitstellbar"
                ],
                footer: "Eine Web App ist günstig und sofort im Browser nutzbar."
            )

        // --- API Integration ---
        case (.apiIntegration, .security):
            return LLMInfo(
                title: "API",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Direkte Tool-Integration",
                    "Automatisiert Workflows"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Mittlere Sicherheit",
                    "Hängt von API-Zugriffsrechten ab"
                ],
                footer: "Eine API verbindet Systeme miteinander und ermöglicht automatisierte Abläufe."
            )

        case (.apiIntegration, .finance):
            return LLMInfo(
                title: "API",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Direkte Tool-Integration",
                    "Nahtlos im Alltag nutzbar"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Mittlere Kosten",
                    "Einmaliger Integrationsaufwand"
                ],
                footer: "Eine API spart langfristig Zeit, weil Systeme automatisch zusammenarbeiten."
            )

        case (.mobileApp, .security):
            return LLMInfo(
                title: "Mobile App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Auf Mobilgeräten nutzbar",
                    "Hohe Benutzerfreundlichkeit"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Niedrigere Sicherheit",
                    "Mehr Risiken durch Endgeräte"
                ],
                footer: "Eine Mobile App läuft auf Smartphones/Tablets und ist überall abrufbar."
            )

        case (.mobileApp, .finance):
            return LLMInfo(
                title: "Mobile App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Überall nutzbar",
                    "Hoher Komfort"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Mittlere Kosten",
                    "Wartung und Updates notwendig"
                ],
                footer: "Eine Mobile App bietet hohe Flexibilität und erleichtert die tägliche Nutzung."
            )
            
        case (.freeUse, .security):
            return LLMInfo(
                title: "Free Use",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Alle Nutzer haben vollen Zugriff",
                    "Sehr geringe Nutzungshürden"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Niedrige Sicherheit",
                    "Höheres Risiko für Fehl- oder Missbrauch"
                ],
                footer: "Free Use bedeutet: jeder kann das System frei nutzen, ohne Zugriffsbeschränkungen."
            )

        case (.freeUse, .finance):
            return LLMInfo(
                title: "Free Use",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Voller Zugriff für alle",
                    "Sehr schnelle Einführung"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Sehr geringe Kosten",
                    "Kein Moderationsaufwand"
                ],
                footer: "Free Use ist die günstigste Option, da keine Governance-Schichten nötig sind."
            )

        case (.moderationFilter, .security):
            return LLMInfo(
                title: "Moderation",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Filtert sensible Inhalte",
                    "Reduziert Informationslecks"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Mittlere Sicherheit",
                    "Blockiert viele riskante Fälle"
                ],
                footer: "Moderation prüft Eingaben/Ausgaben und schützt vor unerwünschten Inhalten."
            )

        case (.moderationFilter, .finance):
            return LLMInfo(
                title: "Moderation",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Filtert sensible Inhalte",
                    "Reduziert Leckrisiken"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Geringe bis mittlere Kosten",
                    "Etwas Pflege- und Review-Aufwand"
                ],
                footer: "Moderation verursacht überschaubare Kosten bei deutlichem Governance-Nutzen."
            )

        case (.roleBasedAccess, .security):
            return LLMInfo(
                title: "Role Access",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Zugriff nach Rollen/Abteilungen",
                    "Least-Privilege-Prinzip"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Hohe Sicherheit",
                    "Strenge Kontrolle über Datenzugriffe"
                ],
                footer: "Role-Based Access bedeutet: Nutzer erhalten nur die Rechte, die sie wirklich brauchen."
            )

        case (.roleBasedAccess, .finance):
            return LLMInfo(
                title: "Role Access",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Rollenbasierte Berechtigungen",
                    "Genaue Steuerung möglich"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Mittlere Kosten",
                    "Administrativer Aufwand höher"
                ],
                footer: "Role-Based Access kostet mehr Verwaltung, bringt aber klare Governance-Strukturen."
            )
            
            case (.localServer, .security):
                return LLMInfo(
                    title: "Local Server",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Läuft auf eigenen Servern",
                        "Nur nutzbar für self-hostbare Modelle"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Sehr hohe Sicherheit",
                        "Volle Daten- und Zugriffs­kontrolle"
                    ],
                    footer: "Ein Local Server bedeutet: alles läuft im eigenen Rechenzentrum."
                )

            case (.localServer, .finance):
                return LLMInfo(
                    title: "Local Server",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Läuft auf eigenen Servern",
                        "Nur nutzbar für self-hostbare Modelle"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Sehr hohe Kosten",
                        "Hardware, Strom und Personal erforderlich"
                    ],
                    footer: "Local Server erfordert hohe Investitionen in Hardware und Betrieb."
                )

            case (.privateCloud, .security):
                return LLMInfo(
                    title: "Private Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Eigene isolierte Cloud-Umgebung",
                        "Von einem Anbieter betrieben"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Mittlere Sicherheit",
                        "Mehr Kontrolle als Public Cloud"
                    ],
                    footer: "Private Cloud ist eine abgeschottete Cloud nur für Ihr Unternehmen."
                )

            case (.privateCloud, .finance):
                return LLMInfo(
                    title: "Private Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Eigene isolierte Cloud-Umgebung",
                        "Extern betrieben"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Hohe Kosten",
                        "Wartung und SLAs verteuern Betrieb"
                    ],
                    footer: "Private Cloud kostet mehr, da sie dediziert und stärker betreut wird."
                )

            case (.cloud, .security):
                return LLMInfo(
                    title: "Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Keine eigene Hardware nötig",
                        "Sehr schnell skalierbar"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Niedrige Sicherheit",
                        "Daten verlassen das Unternehmen"
                    ],
                    footer: "Public Cloud heißt: Sie nutzen die Infrastruktur eines externen Anbieters."
                )

            case (.cloud, .finance):
                return LLMInfo(
                    title: "Cloud",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Keine Hardware nötig",
                        "Sehr schnell startklar"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Niedrige bis mittlere Kosten",
                        "Zahlen pro Nutzung"
                    ],
                    footer: "Public Cloud spart Hardwarekosten und ermöglicht schnellen Start."
                )
            
            case (.standardEncryption, .security):
                return LLMInfo(
                    title: "Standard",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Passwortbasierter Schutz",
                        "Schnell eingerichtet"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Niedrige Sicherheit",
                        "Nicht immer DSGVO-konform"
                    ],
                    footer: "Standardverschlüsselung schützt einfach, aber nicht besonders stark."
                )

            case (.standardEncryption, .finance):
                return LLMInfo(
                    title: "Standard",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Passwortbasierter Schutz",
                        "Schnell eingerichtet"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Sehr geringe Kosten",
                        "Kaum Administrationsaufwand"
                    ],
                    footer: "Standardverschlüsselung ist die günstigste, aber einfachste Schutzoption."
                )

            case (.multiFactorAuth, .security):
                return LLMInfo(
                    title: "Multi-Factor",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Passwort + zweiter Faktor",
                        "Per App oder SMS"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Sehr hohe Sicherheit",
                        "Starker Schutz vor Accountübernahmen"
                    ],
                    footer: "MFA bedeutet Anmeldung mit zwei unabhängigen Sicherheitsfaktoren."
                )

            case (.multiFactorAuth, .finance):
                return LLMInfo(
                    title: "Multi-Factor",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Passwort + zweiter Faktor",
                        "Per App oder SMS"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Hohe Kosten",
                        "Lizenzierung, Support und Schulungen nötig"
                    ],
                    footer: "MFA erhöht die Sicherheit stark, ist aber teuer in Rollout und Betrieb."
                )

            case (.privacyByDesign, .security):
                return LLMInfo(
                    title: "Privacy by Design",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Keine Datenspeicherung",
                        "Anonyme Nutzung"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Sehr hohe Sicherheit",
                        "Personenbezogene Daten werden sofort gelöscht"
                    ],
                    footer: "Privacy by Design bedeutet maximale Privatsphäre ohne Datenspeicherung."
                )

            case (.privacyByDesign, .finance):
                return LLMInfo(
                    title: "Privacy by Design",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Keine Datenspeicherung",
                        "Anonyme Nutzung"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Mittlere bis hohe Kosten",
                        "Aufwand abhängig von Kontrollen und Architektur"
                    ],
                    footer: "Privacy by Design spart Datenhaltung, kann aber technische Zusatzkosten erzeugen."
                )
            
            
            case (.microsoft365, .security):
                return LLMInfo(
                    title: "Microsoft",
                    logoName: "Microsoft",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Integration in Teams und Outlook",
                        "Zugriff auf SharePoint-Dokumente"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Hohe Sicherheit",
                        "EU-Hosting möglich"
                    ],
                    footer: "Microsoft 365 bedeutet Nutzung der bestehenden Microsoft-Umgebung."
                )

            case (.microsoft365, .finance):
                return LLMInfo(
                    title: "Microsoft",
                    logoName: "Microsoft",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "In bestehende MS-Tools eingebettet",
                        "Gute Zusammenarbeit"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Mittlere Kosten",
                        "Lizenz pro Nutzer"
                    ],
                    footer: "Microsoft 365 lohnt sich besonders für bereits MS-basierte Unternehmen."
                )

            case (.googleWorkspace, .security):
                return LLMInfo(
                    title: "Google",
                    logoName: "Google",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Integration mit Gmail & Drive",
                        "Starke Kollaboration"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Hohe Sicherheit",
                        "Gute Sicherheitstechnik",
                    ],
                    footer: "Google Workspace ist stark für Zusammenarbeit."
                )

            case (.googleWorkspace, .finance):
                return LLMInfo(
                    title: "Google",
                    logoName: "Google",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Gmail & Drive Integration",
                        "Gutes Collaboration-Ökosystem"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Geringe bis mittlere Kosten",
                        "Lizenz erforderlich",
                        "Scope limited to Google-stored data"
                    ],
                    footer: "Google Workspace ist günstig, wenn das Unternehmen schon Google nutzt."
                )

            case (.internalSystems, .security):
                return LLMInfo(
                    title: "Internal",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Anbindung interner Datenbanken",
                        "Maximale Datenabdeckung"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Hohe Sicherheit",
                        "Ideal für sensible Informationen"
                    ],
                    footer: "Internal Systems heißt: das Modell nutzt ausschließlich Unternehmensdaten."
                )

            case (.internalSystems, .finance):
                return LLMInfo(
                    title: "Internal",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Zugriff auf interne Datenquellen",
                        "Stark anpassbare Integration"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Hohe Kosten",
                        "Integrations- und Wartungsaufwand"
                    ],
                    footer: "Interne Systeme steigern Datenqualität, sind aber teuer in Entwicklung & Wartung."
                )

            case (.openData, .security):
                return LLMInfo(
                    title: "Open Data",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Nutzt öffentlich verfügbare Webdaten",
                        "Breite externe Abdeckung"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Niedrige Sicherheit",
                        "Fehlinformation möglich"
                    ],
                    footer: "Open Data nutzt freie Webquellen, die nicht kontrolliert oder geprüft sind."
                )

            case (.openData, .finance):
                return LLMInfo(
                    title: "Open Data",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Freie Webinhalte als Datenbasis",
                        "Breite Informationsmenge"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Sehr niedrige Kosten",
                        "Daten sind kostenlos",
                    ],
                    footer: "Open Data ist günstig, erfordert aber zusätzliche Qualitätskontrollen."
                )

            case (.germanyHosting, .security):
                return LLMInfo(
                    title: "Germany",
                    logoName: "Germany",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosting nur in deutschen Rechenzentren",
                        "Erfüllt strenge Datenschutzstandards"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Sehr hohe Sicherheit",
                        "Maximaler Datenschutz"
                    ],
                    footer: "Deutschland Hosting bedeutet höchste Datensicherheit und klare Regeln."
                )

            case (.germanyHosting, .finance):
                return LLMInfo(
                    title: "Germany",
                    logoName: "Germany",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosting in deutschen Rechenzentren",
                        "Sehr starke Datenresidenz"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Mittlere Kosten",
                        "Preisaufschlag für In-Country-Hosting"
                    ],
                    footer: "Deutschland Hosting kostet moderat, bringt aber starke Datenschutzvorteile."
                )

            case (.euHosting, .security):
                return LLMInfo(
                    title: "Europe",
                    logoName: "EU",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosting in EU-Rechenzentren",
                        "GDPR-konform"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Hohe Sicherheit",
                        "Solider EU-Rechtsrahmen"
                    ],
                    footer: "EU-Hosting bietet gute Sicherheit und mehr Anbieterwahl."
                )

            case (.euHosting, .finance):
                return LLMInfo(
                    title: "Europe",
                    logoName: "EU",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Hosting in EU-Rechenzentren",
                        "GDPR-konform"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Mittlere Kosten",
                        "Preis variiert je nach Anbieter und Land"
                    ],
                    footer: "EU-Hosting ist preislich moderat mit stabiler Compliance."
                )

            case (.globalHosting, .security):
                return LLMInfo(
                    title: "Worldwide",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Weltweite Rechenzentren",
                        "Gute Performance über Regionen"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Niedrigere Privatsphäre",
                        "Regionale Unterschiede im Datenschutz"
                    ],
                    footer: "Globales Hosting bietet Reichweite, aber schwächere Datenschutzgarantien."
                )

            case (.globalHosting, .finance):
                return LLMInfo(
                    title: "Worldwide",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Breite Provider-Auswahl",
                        "Hohe globale Verfügbarkeit"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Niedrige Kosten",
                        "Zuschläge für weltweite Compliance"
                    ],
                    footer: "Globales Hosting ist flexibel und günstiger als regionale Optionen."
                )
            
            case (.internalStorage, .security):
                return LLMInfo(
                    title: "Internal Storage",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Zugriff auf feste interne Datenbank",
                        "Manuelle Updates, kein Live-Zugriff"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Mittlere bis hohe Sicherheit",
                        "Risiko abhängig vom Modell"
                    ],
                    footer: "Internal Storage heißt: das Modell nutzt nur eine feste, intern gepflegte Datenquelle."
                )

            case (.internalStorage, .finance):
                return LLMInfo(
                    title: "Internal Storage",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Feste interne Datenquelle",
                        "Manuelle Pflege notwendig"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Niedrige bis mittlere Kosten",
                        "Keine Live-Query-Gebühren"
                    ],
                    footer: "Internal Storage ist günstig, benötigt aber regelmäßige Datenpflege."
                )

            case (.fineTuning, .security):
                return LLMInfo(
                    title: "Fine-Tuning",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Training mit Unternehmensdaten",
                        "Sehr spezifische Antworten"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Niedrige Sicherheit",
                        "Risiko hängt vom Modell und Anbieter ab"
                    ],
                    footer: "Fine-Tuning nutzt interne Daten im Training – Sicherheitsprozesse sind entscheidend."
                )

            case (.fineTuning, .finance):
                return LLMInfo(
                    title: "Fine-Tuning",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Modell an Firmendaten angepasst",
                        "Sehr hohe Antwortqualität"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Hohe Kosten",
                        "Aufwändige Datenaufbereitung und Training"
                    ],
                    footer: "Fine-Tuning liefert Top-Performance, ist aber teuer in Vorbereitung und Training."
                )

            case (.rag, .security):
                return LLMInfo(
                    title: "RAG",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Abruf von Firmendokumenten bei jeder Anfrage",
                        "Hängt stark von Datenqualität ab"
                    ],
                    securityHeader: "Security Overview",
                    securityBullets: [
                        "Sicherheit abhängig von Quellen",
                        "Zugriffsrechte und Logging zentral"
                    ],
                    footer: "RAG nutzt Live-Datenabruf für aktuelle Antworten – benötigt gute Zugriffskontrollen."
                )

            case (.rag, .finance):
                return LLMInfo(
                    title: "RAG",
                    logoName: "titel",
                    overviewHeader: "Overview",
                    overviewBullets: [
                        "Live-Dokumentabruf pro Anfrage",
                        "Bessere Aktualität als Internal Storage"
                    ],
                    securityHeader: "Financial Overview",
                    securityBullets: [
                        "Mittlere Kosten",
                        "Pipeline-, Index- und Hosting-Kosten"
                    ],
                    footer: "RAG liefert aktuelle Antworten, kostet aber laufend durch Retrieval-Pipelines."
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
