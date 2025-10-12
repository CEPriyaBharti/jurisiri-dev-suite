# Implementation Plan

## [Overview]

Create a comprehensive AI Assistant package within the jurisiri-ai library that provides natural language interface for common legal case management tasks through OpenAI function calling.

This implementation adds a new `assistant` package to the existing jurisiri-ai library, enabling advocates to perform case management actions through natural language (text or voice). The assistant will use OpenAI's function calling capabilities to execute predefined tools for creating events, adding notes, sending client updates, and managing case data. The package will be self-contained and integrate seamlessly with existing API services while maintaining proper permission controls and security. Audio input will be transcribed using OpenAI's Whisper API before processing. All actions will use existing database services to ensure consistency and proper authorization.

## [Types]

New type definitions for AI assistant functionality including tool schemas, response formats, and audio handling.

```python
# assistant/schemas.py
from enum import Enum
from typing import Any, Dict, List, Optional, Union
from datetime import datetime
from pydantic import BaseModel, Field

class AssistantToolType(str, Enum):
    CREATE_EVENT = "create_event"
    ADD_NOTE = "add_note"
    SEND_UPDATE = "send_update"
    GET_SUMMARY = "get_summary"
    SCHEDULE_HEARING = "schedule_hearing"

class AudioFormat(str, Enum):
    WAV = "wav"
    MP3 = "mp3"
    M4A = "m4a"
    WEBM = "webm"

class ToolResult(BaseModel):
    success: bool
    message: str
    data: Optional[Dict[str, Any]] = None
    error: Optional[str] = None

class AssistantRequest(BaseModel):
    user_id: int
    case_id: Optional[int] = None
    organization_id: int
    message: Optional[str] = None
    audio_data: Optional[bytes] = None
    audio_format: Optional[AudioFormat] = None
    session_id: Optional[str] = None

class AssistantResponse(BaseModel):
    response: str
    tools_used: List[str] = []
    tool_results: List[ToolResult] = []
    transcription: Optional[str] = None
    session_id: str
    timestamp: datetime

class EventToolParams(BaseModel):
    case_id: int = Field(description="Case ID for the event")
    date: str = Field(description="Event date in YYYY-MM-DD format")
    title: str = Field(description="Event title")
    description: Optional[str] = Field(description="Event description")
    time: Optional[str] = Field(description="Event time in HH:MM format")

class NoteToolParams(BaseModel):
    case_id: int = Field(description="Case ID for the note")
    content: str = Field(description="Note content")
    note_type: str = Field(description="Note type (general, meeting, research, etc.)")

class UpdateToolParams(BaseModel):
    case_id: int = Field(description="Case ID")
    message: str = Field(description="Update message to send")
    urgent: bool = Field(default=False, description="Whether update is urgent")

class SummaryToolParams(BaseModel):
    case_id: int = Field(description="Case ID to summarize")
    include_notes: bool = Field(default=True, description="Include recent notes in summary")

class HearingToolParams(BaseModel):
    case_id: int = Field(description="Case ID for the hearing")
    date: str = Field(description="Hearing date in YYYY-MM-DD format")
    time: str = Field(description="Hearing time in HH:MM format")
    court: str = Field(description="Court name or location")
    details: Optional[str] = Field(description="Additional hearing details")
```

## [Files]

New files to be created within the jurisiri-ai package structure and existing files to be modified.

**New Files:**

- `jurisiri-ai/jurisiri_ai/assistant/__init__.py`: Package initialization and exports
- `jurisiri-ai/jurisiri_ai/assistant/manager.py`: Main AssistantManager class
- `jurisiri-ai/jurisiri_ai/assistant/schemas.py`: Type definitions and Pydantic models
- `jurisiri-ai/jurisiri_ai/assistant/tools/__init__.py`: Tools package initialization
- `jurisiri-ai/jurisiri_ai/assistant/tools/base.py`: Base tool class and interfaces
- `jurisiri-ai/jurisiri_ai/assistant/tools/case_tools.py`: Case management tools
- `jurisiri-ai/jurisiri_ai/assistant/tools/client_tools.py`: Client communication tools
- `jurisiri-ai/jurisiri_ai/assistant/tools/event_tools.py`: Calendar and event tools
- `jurisiri-ai/jurisiri_ai/assistant/transcription/__init__.py`: Transcription package init
- `jurisiri-ai/jurisiri_ai/assistant/transcription/service.py`: Audio transcription service
- `api/src/ai/assistant_routes.py`: New API routes for assistant functionality
- `api/src/ai/assistant_service.py`: Service layer for assistant integration

**Modified Files:**

- `jurisiri-ai/jurisiri_ai/__init__.py`: Add assistant package exports
- `jurisiri-ai/jurisiri_ai/core/providers/openai_provider.py`: Add function calling support
- `api/src/ai/routes.py`: Add assistant route imports
- `api/src/main.py`: Include assistant routes in FastAPI app

**Configuration Updates:**

- `jurisiri-ai/requirements.txt`: Add openai-whisper dependency
- `api/requirements.txt`: Update if needed for new dependencies

## [Functions]

New functions to be implemented and existing functions to be modified.

**New Functions:**

_AssistantManager (assistant/manager.py):_

- `__init__(self, ai_manager: JuriSiriAI, db_session: AsyncSession)`
- `async process_request(self, request: AssistantRequest) -> AssistantResponse`
- `async transcribe_audio(self, audio_data: bytes, format: AudioFormat) -> str`
- `async execute_tools(self, messages: List[Dict], tools: List[Dict]) -> List[ToolResult]`
- `_get_available_tools(self, user_id: int, case_id: Optional[int]) -> List[Dict]`

_BaseTool (assistant/tools/base.py):_

- `__init__(self, db_session: AsyncSession, user_id: int, organization_id: int)`
- `async execute(self, **kwargs) -> ToolResult`
- `get_function_definition(self) -> Dict[str, Any]`
- `async check_permissions(self, **kwargs) -> bool`

_EventTool (assistant/tools/event_tools.py):_

- `async execute(self, case_id: int, date: str, title: str, description: str = None, time: str = None) -> ToolResult`
- `get_function_definition(self) -> Dict[str, Any]`

_NoteTool (assistant/tools/case_tools.py):_

- `async execute(self, case_id: int, content: str, note_type: str) -> ToolResult`
- `get_function_definition(self) -> Dict[str, Any]`

_UpdateTool (assistant/tools/client_tools.py):_

- `async execute(self, case_id: int, message: str, urgent: bool = False) -> ToolResult`
- `get_function_definition(self) -> Dict[str, Any]`

_TranscriptionService (assistant/transcription/service.py):_

- `__init__(self, openai_client: openai.AsyncOpenAI)`
- `async transcribe(self, audio_data: bytes, format: AudioFormat) -> str`
- `_prepare_audio_file(self, audio_data: bytes, format: AudioFormat) -> io.BytesIO`

**Modified Functions:**

_OpenAIProvider.generate_response():_

- Add support for `tools` parameter in API calls
- Handle function calling responses
- Process tool call results and continue conversation

_AIService.initialize():_

- Initialize AssistantManager instance
- Pass database session to assistant manager

## [Classes]

New classes to be implemented and existing classes to be modified.

**New Classes:**

_AssistantManager (assistant/manager.py):_

- Main coordinator for AI assistant functionality
- Handles request processing, tool execution, and response formatting
- Key methods: process_request, transcribe_audio, execute_tools
- Integrates with existing JuriSiriAI manager

_BaseTool (assistant/tools/base.py):_

- Abstract base class for all assistant tools
- Provides common functionality: permission checking, error handling
- Key methods: execute (abstract), get_function_definition (abstract), check_permissions

_CreateEventTool (assistant/tools/event_tools.py):_

- Inherits from BaseTool
- Creates calendar events for cases
- Integrates with existing event services

_AddNoteTool (assistant/tools/case_tools.py):_

- Inherits from BaseTool
- Adds notes to cases with different types
- Uses existing case note models and services

_SendUpdateTool (assistant/tools/client_tools.py):_

- Inherits from BaseTool
- Sends updates to case clients
- Creates update records in database

_GetSummaryTool (assistant/tools/case_tools.py):_

- Inherits from BaseTool
- Retrieves and formats case summaries
- Read-only tool for information retrieval

_ScheduleHearingTool (assistant/tools/event_tools.py):_

- Inherits from BaseTool
- Specialized tool for court hearing scheduling
- Creates specific hearing event types

_TranscriptionService (assistant/transcription/service.py):_

- Handles audio-to-text conversion using OpenAI Whisper
- Supports multiple audio formats
- Error handling and audio preprocessing

**Modified Classes:**

_OpenAIProvider:_

- Add function calling capabilities to generate_response method
- Handle tool call responses and multi-turn conversations
- Update model capabilities metadata

## [Dependencies]

New packages and version changes required for the implementation.

**New Dependencies:**

- Add to `jurisiri-ai/requirements.txt`:
  ```
  openai-whisper>=1.1.10
  ```

**Existing Dependencies (verify versions):**

- `openai>=1.0.0` (already present, ensure function calling support)
- `pydantic>=2.0.0` (already present, for schema definitions)
- `structlog` (already present, for logging)
- `sqlalchemy[asyncio]` (already present, for database operations)

**Integration Requirements:**

- No changes to existing API dependencies
- Assistant functionality integrates through existing AI service layer
- Uses existing authentication and authorization mechanisms

## [Testing]

Test file requirements and validation strategies for the assistant functionality.

**New Test Files:**

- `jurisiri-ai/tests/test_assistant_manager.py`: Unit tests for AssistantManager
- `jurisiri-ai/tests/test_tools/`: Directory for tool-specific tests
- `jurisiri-ai/tests/test_tools/test_event_tools.py`: Event tool tests
- `jurisiri-ai/tests/test_tools/test_case_tools.py`: Case tool tests
- `jurisiri-ai/tests/test_tools/test_client_tools.py`: Client tool tests
- `jurisiri-ai/tests/test_transcription.py`: Audio transcription tests
- `api/tests/test_assistant_routes.py`: API endpoint tests

**Test Scenarios:**

- Audio transcription accuracy and error handling
- Tool permission validation and security
- Function calling integration with OpenAI
- Database transaction handling in tools
- Error propagation and user feedback
- Mock testing for external API dependencies

**Integration Tests:**

- End-to-end assistant request processing
- Database consistency after tool execution
- Permission enforcement across different user roles
- Audio format compatibility and conversion

**Mock Requirements:**

- Mock OpenAI Whisper API responses
- Mock database operations for unit tests
- Mock function calling responses from OpenAI
- Test data fixtures for cases, clients, and events

## [Implementation Order]

Numbered steps showing the logical order of changes to minimize conflicts and ensure successful integration.

1. **Create Base Infrastructure**

   - Create assistant package structure and **init**.py files
   - Implement schemas.py with all type definitions
   - Set up base tool class and abstract methods

2. **Implement Transcription Service**

   - Create transcription service with OpenAI Whisper integration
   - Add audio format handling and validation
   - Implement error handling for transcription failures

3. **Develop Core Tools**

   - Implement CreateEventTool for calendar integration
   - Implement AddNoteTool for case notes
   - Implement SendUpdateTool for client communication
   - Test each tool individually with mock data

4. **Extend OpenAI Provider**

   - Add function calling support to OpenAIProvider.generate_response()
   - Handle tool call responses and multi-turn conversations
   - Update provider capabilities and metadata

5. **Create Assistant Manager**

   - Implement AssistantManager with tool orchestration
   - Add request processing and response formatting
   - Integrate transcription service for audio handling

6. **Add API Integration**

   - Create assistant_service.py in API layer
   - Implement assistant_routes.py with REST endpoints
   - Update main API routes to include assistant endpoints

7. **Implement Remaining Tools**

   - Add GetSummaryTool for case information retrieval
   - Add ScheduleHearingTool for court scheduling
   - Implement tool permission validation

8. **Testing and Validation**

   - Create comprehensive test suite
   - Test audio transcription with various formats
   - Validate tool security and permission enforcement
   - End-to-end testing with real scenarios

9. **Integration and Documentation**
   - Update package exports and imports
   - Add configuration documentation
   - Create usage examples and API documentation
   - Performance testing and optimization
