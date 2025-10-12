# AI Assistant Frontend Integration Plan

## Overview

This document outlines the implementation plan for integrating the completed AI Assistant backend with the JuriSiri frontend application. The goal is to create a universal AI assistant accessible from any page for logged-in users.

## 🎯 Project Goals

### Primary Objectives

1. **Universal Access**: AI assistant available from any page when user is logged in
2. **Multi-Modal Input**: Support both text and voice input
3. **Conversation Continuity**: Maintain conversation state across page navigation
4. **Tool Integration**: Visual feedback for AI tool execution
5. **Responsive Design**: Works seamlessly on desktop and mobile

### User Experience Goals

- **Intuitive Interface**: Chat-style interaction familiar to users
- **Quick Access**: Floating action button for immediate availability
- **Context Awareness**: Assistant understands current page/case context
- **Performance**: Fast response times and smooth interactions

## 🏗️ Architecture Overview

### Component Hierarchy

```
App Layout
├── AIAssistantProvider (Global Context)
├── Page Content
└── AIAssistantContainer
    ├── AIAssistantFAB (Floating Action Button)
    └── AIAssistantModal (Chat Interface)
        ├── ChatHeader
        ├── ChatMessages
        │   ├── UserMessage
        │   ├── AssistantMessage
        │   └── ToolExecutionIndicator
        ├── VoiceRecorder
        └── ChatInput
```

### State Management

```typescript
interface AIAssistantState {
  isOpen: boolean;
  sessionId: string | null;
  messages: Message[];
  isLoading: boolean;
  isRecording: boolean;
  currentContext: {
    pageUrl: string;
    caseId?: number;
    userId: number;
    organizationId: number;
  };
}
```

## 📱 Component Specifications

### 1. AIAssistantProvider (Context)

**Purpose**: Global state management for AI assistant

**Features**:

- Session management across page navigation
- Message history persistence
- Authentication integration
- Context awareness (current page, case, etc.)

**API Integration**:

```typescript
interface AIAssistantAPI {
  sendMessage(message: string): Promise<AssistantResponse>;
  sendAudio(audioBlob: Blob, format: string): Promise<AssistantResponse>;
  getSessionContext(sessionId: string): Promise<SessionContext>;
  getAvailableTools(): Promise<Tool[]>;
}
```

### 2. AIAssistantFAB (Floating Action Button)

**Purpose**: Quick access button visible on all pages

**Design Requirements**:

- Fixed position (bottom-right corner)
- Animated microphone/chat icon
- Notification badge for unread messages
- Smooth hover and click animations
- Z-index management to appear above all content

**States**:

- `idle`: Default blue chat icon
- `recording`: Red microphone with pulse animation
- `processing`: Loading spinner
- `notification`: Badge with unread count

### 3. AIAssistantModal (Main Chat Interface)

**Purpose**: Primary chat interface with full conversation history

**Layout**:

- **Header**: Title, minimize/close buttons, session indicator
- **Messages Area**: Scrollable conversation history
- **Input Area**: Text input + voice button + send button
- **Footer**: Tool status, session info

**Responsive Behavior**:

- Desktop: Modal overlay (500px width)
- Tablet: Slide-in sidebar (400px width)
- Mobile: Full-screen overlay

### 4. ChatMessages Components

**Purpose**: Display conversation history with rich formatting

**Message Types**:

- **UserMessage**: Right-aligned, blue background
- **AssistantMessage**: Left-aligned, gray background, typing animation
- **ToolExecution**: Special indicator showing tool being executed
- **SystemMessage**: Center-aligned, subtle styling for system notifications

**Features**:

- Auto-scroll to latest message
- Message timestamps
- Copy message functionality
- Markdown rendering for assistant responses

### 5. VoiceRecorder Component

**Purpose**: Handle audio recording and playback

**Features**:

- Visual waveform during recording
- Real-time audio level indicator
- Recording duration display
- Playback controls for recorded audio
- Format conversion (to supported formats)

**Technical Requirements**:

- MediaRecorder API integration
- Audio permission handling
- File size validation (25MB limit)
- Format support: WAV, MP3, M4A, WEBM

### 6. ChatInput Component

**Purpose**: Text input with enhanced features

**Features**:

- Multi-line text input with auto-resize
- Send button with loading state
- Voice recording toggle
- Emoji picker (optional)
- File attachment for audio (fallback)

## 🔧 Technical Implementation

### Frontend API Client

```typescript
// lib/api/ai-assistant.ts
class AIAssistantClient {
  private baseURL: string;
  private sessionId: string | null = null;

  async sendTextMessage(
    message: string,
    context: AssistantContext
  ): Promise<AssistantResponse> {
    const response = await fetch("/api/ai/assistant/text", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${getAuthToken()}`,
      },
      body: JSON.stringify({
        message,
        case_id: context.caseId,
        session_id: this.sessionId,
      }),
    });

    const data = await response.json();
    this.sessionId = data.session_id;
    return data;
  }

  async sendAudioMessage(
    audioBlob: Blob,
    format: string,
    context: AssistantContext
  ): Promise<AssistantResponse> {
    const formData = new FormData();
    formData.append("audio_file", audioBlob, `recording.${format}`);
    formData.append("case_id", context.caseId?.toString() || "");
    formData.append("session_id", this.sessionId || "");

    const response = await fetch("/api/ai/assistant/audio", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${getAuthToken()}`,
      },
      body: formData,
    });

    const data = await response.json();
    this.sessionId = data.session_id;
    return data;
  }
}
```

### React Context Setup

```typescript
// contexts/AIAssistantContext.tsx
interface AIAssistantContextType {
  state: AIAssistantState;
  actions: {
    toggleAssistant: () => void;
    sendMessage: (message: string) => Promise<void>;
    startRecording: () => void;
    stopRecording: () => Promise<void>;
    clearSession: () => void;
  };
}

export const AIAssistantProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [state, setState] = useState<AIAssistantState>(initialState);
  const apiClient = new AIAssistantClient();

  // Implementation details...

  return (
    <AIAssistantContext.Provider value={{ state, actions }}>
      {children}
    </AIAssistantContext.Provider>
  );
};
```

### Audio Recording Hook

```typescript
// hooks/useVoiceRecording.ts
export const useVoiceRecording = () => {
  const [isRecording, setIsRecording] = useState(false);
  const [audioBlob, setAudioBlob] = useState<Blob | null>(null);
  const [duration, setDuration] = useState(0);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream);

      mediaRecorder.ondataavailable = (event) => {
        setAudioBlob(event.data);
      };

      mediaRecorder.start();
      setIsRecording(true);
      mediaRecorderRef.current = mediaRecorder;
    } catch (error) {
      console.error("Failed to start recording:", error);
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current) {
      mediaRecorderRef.current.stop();
      setIsRecording(false);
    }
  };

  return { isRecording, audioBlob, duration, startRecording, stopRecording };
};
```

## 🎨 UI/UX Design Specifications

### Design System Integration

- **Colors**: Use existing Tailwind color palette
- **Typography**: Consistent with app typography (Inter font)
- **Spacing**: Follow 4px grid system
- **Shadows**: Subtle shadows for elevation
- **Animations**: Smooth transitions (200-300ms)

### Floating Action Button Design

```css
.ai-assistant-fab {
  position: fixed;
  bottom: 24px;
  right: 24px;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  box-shadow: 0 8px 32px rgba(59, 130, 246, 0.3);
  transition: all 0.3s ease;
  z-index: 9999;
}

.ai-assistant-fab:hover {
  transform: scale(1.1);
  box-shadow: 0 12px 40px rgba(59, 130, 246, 0.4);
}
```

### Modal Design

```css
.ai-assistant-modal {
  position: fixed;
  bottom: 100px;
  right: 24px;
  width: 400px;
  height: 600px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  transform: translateY(100%);
  transition: transform 0.3s ease;
}

.ai-assistant-modal.open {
  transform: translateY(0);
}
```

### Message Bubbles

```css
.message-user {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  margin-left: auto;
  margin-right: 0;
  border-radius: 18px 18px 4px 18px;
}

.message-assistant {
  background: #f3f4f6;
  color: #1f2937;
  margin-left: 0;
  margin-right: auto;
  border-radius: 18px 18px 18px 4px;
}
```

## 📱 Responsive Design Strategy

### Breakpoints

- **Mobile**: < 768px (Full-screen modal)
- **Tablet**: 768px - 1024px (Slide-in sidebar)
- **Desktop**: > 1024px (Bottom-right modal)

### Mobile Optimizations

- Touch-friendly button sizes (44px minimum)
- Swipe gestures for closing modal
- Native-like animations
- Keyboard handling for input

### Accessibility Features

- ARIA labels for all interactive elements
- Keyboard navigation support
- Screen reader announcements
- High contrast mode support
- Focus management

## 🔗 Integration Points

### Authentication Integration

```typescript
// Integrate with existing auth system
const { user, organization } = useAuth();

const assistantContext = {
  userId: user.id,
  organizationId: organization.id,
  pageUrl: router.asPath,
  caseId: getCurrentCaseId(), // Extract from URL or context
};
```

### Page Context Awareness

```typescript
// Extract context from current page
const getPageContext = () => {
  const path = router.asPath;

  // Case page context
  if (path.includes("/cases/")) {
    const caseId = extractCaseIdFromPath(path);
    return { type: "case", caseId };
  }

  // Client page context
  if (path.includes("/clients/")) {
    const clientId = extractClientIdFromPath(path);
    return { type: "client", clientId };
  }

  // Dashboard context
  if (path.includes("/dashboard")) {
    return { type: "dashboard" };
  }

  return { type: "general" };
};
```

### Real-time Updates (Optional)

```typescript
// WebSocket integration for real-time conversation updates
const useWebSocket = (sessionId: string) => {
  useEffect(() => {
    if (!sessionId) return;

    const ws = new WebSocket(`ws://localhost:8000/ws/assistant/${sessionId}`);

    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      // Handle real-time updates
    };

    return () => ws.close();
  }, [sessionId]);
};
```

## 🚀 Implementation Phases

### Phase 1: Core Infrastructure (Week 1)

1. **Setup Context Provider**

   - Create AIAssistantContext
   - Implement basic state management
   - Add to app layout

2. **Basic API Client**

   - Create API client class
   - Implement text message sending
   - Handle authentication

3. **Floating Action Button**
   - Create FAB component
   - Add positioning and styling
   - Implement toggle functionality

### Phase 2: Chat Interface (Week 2)

1. **Modal Component**

   - Create modal structure
   - Implement open/close animations
   - Add responsive behavior

2. **Message Components**

   - User and assistant message bubbles
   - Message list with auto-scroll
   - Loading indicators

3. **Text Input**
   - Multi-line input component
   - Send button with loading states
   - Keyboard shortcuts

### Phase 3: Voice Integration (Week 3)

1. **Voice Recording**

   - MediaRecorder integration
   - Permission handling
   - Visual recording indicators

2. **Audio Upload**

   - File upload functionality
   - Progress indicators
   - Error handling

3. **Voice Feedback**
   - Transcription display
   - Audio playback controls
   - Format conversion

### Phase 4: Enhanced Features (Week 4)

1. **Tool Execution Feedback**

   - Visual indicators for tool execution
   - Progress states
   - Success/error feedback

2. **Session Management**

   - Persistent session storage
   - Session recovery
   - Multiple session support

3. **Performance Optimization**
   - Message virtualization
   - Lazy loading
   - Bundle optimization

## 📝 Development Guidelines

### Code Organization

```
web/components/ai-assistant/
├── AIAssistantProvider.tsx      # Context provider
├── AIAssistantFAB.tsx          # Floating action button
├── AIAssistantModal.tsx        # Main modal component
├── ChatHeader.tsx              # Modal header
├── ChatMessages/
│   ├── MessageList.tsx         # Message container
│   ├── UserMessage.tsx         # User message bubble
│   ├── AssistantMessage.tsx    # Assistant message bubble
│   └── ToolIndicator.tsx       # Tool execution indicator
├── VoiceRecorder/
│   ├── VoiceRecorder.tsx       # Main recorder component
│   ├── AudioVisualizer.tsx     # Waveform display
│   └── RecordingControls.tsx   # Record/stop controls
└── ChatInput/
    ├── ChatInput.tsx           # Main input component
    └── InputControls.tsx       # Send/voice buttons
```

### Testing Strategy

1. **Unit Tests**: All components and hooks
2. **Integration Tests**: API client and context
3. **E2E Tests**: Complete user flows
4. **Accessibility Tests**: ARIA compliance and keyboard navigation
5. **Performance Tests**: Bundle size and runtime performance

### Error Handling

- Graceful degradation for API failures
- Offline support with queue management
- User-friendly error messages
- Retry mechanisms for failed requests

## 🔧 Environment Configuration

### Required Environment Variables

```bash
# Frontend (.env.local)
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
NEXT_PUBLIC_WS_URL=ws://localhost:8000

# Backend (if not already configured)
OPENAI_API_KEY=your_openai_api_key_here
```

### Feature Flags

```typescript
// lib/config/features.ts
export const features = {
  aiAssistant: {
    enabled: process.env.NEXT_PUBLIC_AI_ASSISTANT_ENABLED === "true",
    voiceInput: process.env.NEXT_PUBLIC_VOICE_INPUT_ENABLED === "true",
    realtime: process.env.NEXT_PUBLIC_REALTIME_ENABLED === "true",
  },
};
```

## 📊 Success Metrics

### Technical Metrics

- Page load impact: < 100ms additional load time
- Bundle size increase: < 50KB gzipped
- API response time: < 2 seconds for text, < 10 seconds for audio
- Error rate: < 1% for API calls

### User Experience Metrics

- Time to first interaction: < 3 seconds
- Voice recording success rate: > 95%
- User session length: > 5 messages average
- Tool execution success rate: > 90%

---

**Document Version**: 1.0
**Created**: January 10, 2025
**Next Review**: After Phase 1 completion
**Priority**: High
