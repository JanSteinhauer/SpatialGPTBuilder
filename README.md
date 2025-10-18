# 🧩 Spatial Governance Simulator (Vision Pro HCI Project)

### Human–Computer Interaction Prototype on AI Governance & Decision-Making

---

## 🌍 Overview

The **Spatial Governance Simulator** is an **Apple Vision Pro** research prototype exploring how **immersive interfaces** can make **AI governance**, **data security**, and **cost-performance trade-offs** more tangible.

Participants take on **different organizational roles** such as **Security Lead** and **FinOps Lead** and make simulated decisions about the setup and operation of a **large-language-model system (LLM)** for a company.
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
Minimize security risks and avoid compliance violations, while observing how these decisions affect performance and cost.

---

### 💰 FinOps Lead

**Focus:** Cost, performance, and energy efficiency
**Responsible for:**

* Selecting an AI model (cost / latency / energy trade-off)
* Monitoring the total budget and performance metrics
* Estimating yearly energy consumption and optimizing inference time (< 2 s)

**Goal:**
Maximize system performance at minimal cost and energy use, while ensuring that compliance and security remain within acceptable bounds.

---

## 💰 Finance Task — KPI Overview

| **KPI**                                    | **Description**                                   | **Role Impact**                             |
| ------------------------------------------ | ------------------------------------------------- | ------------------------------------------- |
| Blended price / 1K tokens ≤ **$0.010**     | Maintain low average token cost across all tiers. | Ensures cost efficiency and budget control. |
| Avg tokens / query ≤ **2,000**             | Keep prompt and output size compact.              | Reduces compute cost and latency.           |
| Cost / query ≤ **$0.020**                  | Enforce per-request cost limit.                   | Guarantees scalability and predictability.  |
| Monthly spend within **±10%** of budget    | Track total usage vs allocated funds.             | Improves financial accountability.          |
| ≥ **70%** requests on low-cost tier        | Route standard tasks to cheaper models.           | Optimizes resource allocation.              |
| Cache hit rate ≥ **35%**                   | Reuse previous results where applicable.          | Saves costs and improves speed.             |
| RAG pipeline cost share ≤ **25%**          | Keep retrieval-augmentation overheads low.        | Balances data freshness vs. cost.           |
| Adoption per € (MAU / monthly €) ≥ **1.5** | Measure monthly active users per Euro spent.      | Links financial spend to real user impact.  |

---

## 🔒 Security Task — KPI Overview

| **KPI**                                                           | **Description**                                    | **Role Impact**                          |
| ----------------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------- |
| Requests processed in **DE/EU ≥ 98%**                             | Keep data residency within EU jurisdictions.       | Ensures GDPR and compliance alignment.   |
| Sensitive-data exposure incidents: **0 / 10,000**                 | Prevent data leaks or unintended sharing.          | Protects reputation and trust.           |
| Moderation/DLP block rate: **1–5 / 1,000** (≤ 2% false positives) | Detect risky content with minimal friction.        | Balances safety and usability.           |
| MFA coverage: **100%**                                            | Enforce secure authentication for all users.       | Reduces unauthorized access risk.        |
| Log/data retention ≤ **14 days**                                  | Minimize how long user data is stored.             | Supports privacy-by-design principles.   |
| Users on least-privilege RBAC ≥ **95%**                           | Limit access to essential data only.               | Strengthens internal security posture.   |
| Third-party processing ≤ **5%**                                   | Restrict external handling of sensitive workloads. | Mitigates exposure and dependency risks. |

---
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

