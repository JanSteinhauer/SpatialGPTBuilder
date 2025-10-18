# 🧩 Spatial Governance Simulator (Vision Pro HCI Project)

### Human–Computer Interaction Prototype on AI Governance & Decision-Making

---

## 🌍 Overview

The **Spatial Governance Simulator** is an **Apple Vision Pro** research prototype exploring how **immersive interfaces** can make **AI governance**, **data security**, and **cost-performance trade-offs** more tangible.

Participants take on **different organizational roles** — such as **Security Lead** and **FinOps Lead** — and make simulated decisions about the setup and operation of a **large-language-model system (LLM)** for a company.
Each decision influences **metrics** like energy use, latency, compliance, and cost, encouraging **collaborative negotiation** and **ethical reflection** in a spatial, visual environment.

This project is part of a **Human–Computer Interaction study** investigation.

---

## 👥 Roles

### 🔒 Security Lead

**Focus:** Data security and compliance
**Responsible for:**

* Choosing the hosting location (🇩🇪 DE / 🇪🇺 EU / 🌎 Non-EU)
* Implementing data-protection measures (masking, encryption, DPA)
* Managing access control (roles, permissions, audit trails)

**Goal:**
Minimize security risks and avoid compliance violations — while observing how these decisions affect performance and cost.

---

### 💰 FinOps Lead

**Focus:** Cost, performance, and energy efficiency
**Responsible for:**

* Selecting an AI model (cost / latency / energy trade-off)
* Monitoring the total budget and performance metrics
* Estimating yearly energy consumption and optimizing inference time (< 2 s)

**Goal:**
Maximize system performance at minimal cost and energy use — while ensuring that compliance and security remain within acceptable bounds.

---

## 📊 Metrics (Under Development)

| Metric                | Description                              | Role Impact   |
| --------------------- | ---------------------------------------- | ------------- |
| **Latency**           | Response time of the model               | FinOps Lead   |
| **Energy Efficiency** | Power consumption (kWh / year)           | FinOps Lead   |
| **Data Security**     | Level of encryption, masking, compliance | Security Lead |
| **Cost per Request**  | Financial cost of inference              | FinOps Lead   |
| **Compliance Score**  | GDPR / DPA adherence                     | Security Lead |
| **User Satisfaction** | System usability and transparency        | Both          |

---

## 🧠 HCI Research Focus

* **Decision Awareness:** How clearly can users perceive the effect of their choices?
* **Trade-off Visualization:** Can a spatial UI improve ethical reflection and negotiation?
* **Collaborative Immersion:** How do users communicate in mixed-reality roles?

---

## 💻 Current Implementation

Currently, only the **widget system** is implemented:

---

## 🔧 Configuration (App Intent)

Use the **configuration UI** to choose the item shown in the widget:

```swift
enum LLMChoice: String, AppEnum {
    // Providers
    case chatgpt, anthropic, gemini, gemma, llama
    // Delivery form factors
    case standaloneWebApp, apiIntegration, mobileApp
    // Access & governance
    case freeUse, moderationFilter, roleBasedAccess
    // Hosting models
    case localServer, privateCloud, cloud
    // Security measures
    case standardEncryption, multiFactorAuth, privacyByDesign
    // Enterprise suites
    case microsoft365, googleWorkspace
    // Data sources
    case internalSystems, openData
    // Regions
    case germanyHosting, euHosting, globalHosting
    // Data strategies
    case internalStorage, fineTuning, rag
}
```
---

## ⚙️ Tech Stack

* **Language:** Swift / SwiftUI
* **Platform:** visionOS (Apple Vision Pro)
* **Frameworks:** WidgetKit, AppIntents, RealityKit
* **Design Principles:** Minimal, glanceable spatial UI for decision transparency

---

## 👨‍💻 License

MIT License
For any questiosn contact **Jan Steinhauer** jan.armin.steinhauer@gmail.com
