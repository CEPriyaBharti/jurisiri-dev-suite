# Dashboard Backend Requirements - Side Notes

## Overview

This document outlines the backend API requirements for the enhanced dashboard components added to the advocate portal. These are currently UI-only implementations that will need backend functionality for full operation.

## Current Status

- ✅ **UI Components**: All three components implemented with realistic mock data
- ⏳ **Backend APIs**: To be developed after fixing major system issues
- 🎯 **Priority**: Medium (after critical bug fixes)

---

## 🤖 AI Legal Assistant Widget

### **Current Implementation**

- Gradient UI with interactive elements
- Mock quick action cards (Draft Contract, Legal Research, Case Analysis)
- Chat input interface

### **Required Backend APIs**

#### **1. AI Document Generation**

```
POST /api/ai/generate-document
Body: {
  "template_type": "contract" | "brief" | "motion",
  "case_id": number,
  "parameters": object
}
Response: {
  "document_id": string,
  "content": string,
  "template_used": string
}
```

#### **2. Legal Research**

```
POST /api/ai/legal-research
Body: {
  "query": string,
  "jurisdiction": string,
  "case_types": string[]
}
Response: {
  "results": [
    {
      "case_name": string,
      "citation": string,
      "relevance_score": number,
      "summary": string
    }
  ]
}
```

#### **3. Case Analysis**

```
POST /api/ai/analyze-case
Body: {
  "case_id": number,
  "analysis_type": "strategy" | "timeline" | "documents"
}
Response: {
  "insights": string[],
  "recommendations": string[],
  "risk_factors": string[]
}
```

#### **4. AI Chat History**

```
GET /api/ai/conversations
POST /api/ai/conversations
PUT /api/ai/conversations/{id}
```

---

## ⏰ Deadline & Task Management

### **Current Implementation**

- Priority-based visual system (urgent/pending/completed)
- Mock tasks with realistic deadlines
- Color-coded status indicators

### **Required Backend APIs**

#### **1. Task Management System**

```
Database Schema:
- tasks table with:
  - id, title, description
  - priority (urgent/high/medium/low)
  - status (pending/in_progress/completed)
  - due_date, reminder_date
  - case_id (optional)
  - advocate_id, organization_id
```

#### **2. Task CRUD Operations**

```
GET /api/tasks - List tasks with filters
POST /api/tasks - Create new task
PUT /api/tasks/{id} - Update task
DELETE /api/tasks/{id} - Delete task
```

#### **3. Deadline Analytics**

```
GET /api/tasks/deadlines
Response: {
  "urgent": Task[],
  "upcoming": Task[],
  "overdue": Task[]
}
```

#### **4. Automated Reminders**

```
Background service for:
- Email notifications
- In-app alerts
- Deadline escalation
```

---

## 📱 Communication Hub

### **Current Implementation**

- Mock client messages with avatars
- Status indicators (new/sent/follow-up)
- Quick action buttons

### **Required Backend APIs**

#### **1. Messaging System**

```
Database Schema:
- messages table:
  - id, sender_id, recipient_id
  - message_type (chat/update/notification)
  - content, attachments
  - read_status, sent_at
  - case_id (optional)

- conversations table:
  - id, advocate_id, client_id
  - last_message_at, unread_count
```

#### **2. Message Operations**

```
GET /api/messages/conversations - List conversations
GET /api/messages/{conversation_id} - Get messages
POST /api/messages - Send message
PUT /api/messages/{id}/read - Mark as read
```

#### **3. Client Updates System**

```
POST /api/client-updates
Body: {
  "client_id": number,
  "case_id": number,
  "update_type": "status" | "document" | "hearing",
  "content": string,
  "automated": boolean
}
```

#### **4. Notification Management**

```
GET /api/notifications/unread-count
POST /api/notifications/mark-read
GET /api/notifications/activity-timeline
```

---

## Development Priority

### **Phase 1 (Essential for POC)**

1. **Task Management API** - Core CRUD operations
2. **Basic Messaging** - Client-advocate communication
3. **Notification Counts** - Unread message tracking

### **Phase 2 (Enhancement)**

4. **AI Document Generation** - Template system
5. **Automated Reminders** - Email/SMS notifications
6. **Advanced AI Features** - Research & analysis

### **Phase 3 (Advanced)**

7. **Real-time Messaging** - WebSocket implementation
8. **AI Chat History** - Conversation persistence
9. **Legal Research API** - External integrations

---

## Technical Considerations

### **Database Changes Needed**

- Add `tasks` table with priority/status fields
- Add `messages` and `conversations` tables
- Add `ai_conversations` table for chat history
- Extend existing tables with notification fields

### **External Integrations**

- AI/ML services for document generation
- Legal research databases (Westlaw, LexisNexis)
- Email/SMS providers for notifications
- WebSocket for real-time features

### **Performance Considerations**

- Implement caching for AI responses
- Use pagination for message history
- Background jobs for notifications
- Database indexing for quick queries

---

## Next Steps (When Ready)

1. Design detailed database schema
2. Create API specification documents
3. Set up development environment for new features
4. Implement core task management first
5. Add messaging system second
6. Integrate AI features last

**Note**: All dashboard components currently display mock data and are fully functional from a UI perspective. Backend integration can be done incrementally without affecting the user experience.
