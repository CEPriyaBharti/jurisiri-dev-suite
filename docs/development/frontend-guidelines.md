# JuriSiri Frontend Development Guidelines

## 🎯 Core Principles for Cline Development

### Component Philosophy

- **Keep components SMALL and FOCUSED** - Each component should have a single responsibility
- **Prefer composition over complexity** - Build complex UIs by combining simple components
- **Use TypeScript strictly** - All components must have proper type definitions

### Folder Structure Rules

```
web/
├── app/                          # Next.js app directory (pages only)
├── components/                   # All reusable components
│   ├── ui/                       # shadcn/ui base components
│   ├── forms/                    # Form-specific components
│   ├── layout/                   # Navigation, headers, sidebars
│   ├── features/                 # Feature-specific components (cases, clients, etc.)
│   └── common/                   # Generic reusable components
├── lib/                          # Utilities and configurations
│   ├── api/                      # API client and endpoints
│   ├── hooks/                    # Custom React hooks
│   ├── utils/                    # Helper functions
│   ├── validations/              # Zod schemas for forms
│   └── constants/                # App-wide constants
├── types/                        # TypeScript definitions
└── styles/                       # Additional CSS if needed
```

### Component Creation Standards

#### 1. Component File Naming

- Use kebab-case for files: `case-list.tsx`, `client-form.tsx`
- Use PascalCase for component names: `CaseList`, `ClientForm`
- Include component type in name: `CaseListItem`, `CaseListContainer`

#### 2. Component Structure Template

```typescript
// components/features/cases/case-list-item.tsx
import { Card } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Case } from "@/types/case"

interface CaseListItemProps {
  case: Case
  onSelect?: (caseId: string) => void
  className?: string
}

export function CaseListItem({ case, onSelect, className }: CaseListItemProps) {
  return (
    <Card className={className}>
      {/* Component content */}
    </Card>
  )
}
```

#### 3. Props Interface Rules

- Always define explicit props interface
- Include optional `className?: string` for styling flexibility
- Use descriptive prop names: `onCaseSelect` not `onClick`
- Prefer specific types over `any`

### API Integration Standards

#### 1. API Client Structure

```typescript
// lib/api/cases.ts
export const casesApi = {
  getAll: () => fetch("/api/cases"),
  getById: (id: string) => fetch(`/api/cases/${id}`),
  create: (data: CreateCaseData) =>
    fetch("/api/cases", { method: "POST", body: JSON.stringify(data) }),
  update: (id: string, data: UpdateCaseData) =>
    fetch(`/api/cases/${id}`, { method: "PUT", body: JSON.stringify(data) }),
};
```

#### 2. Custom Hooks for Data

```typescript
// lib/hooks/use-cases.ts
export function useCases() {
  // React Query or SWR implementation
}

export function useCase(id: string) {
  // Single case fetching
}
```

### State Management Rules

#### 1. State Hierarchy

- **Local State**: Component-specific data (useState, useReducer)
- **Server State**: API data (React Query/SWR)
- **Global State**: App-wide data (Zustand)
- **Form State**: Form data (React Hook Form)

#### 2. When to Use Each

- Use local state for UI interactions (modals, dropdowns)
- Use server state for all API data
- Use global state for user session, theme, navigation
- Use form state for all forms

### Styling Guidelines

#### 1. Tailwind CSS Usage

- Use Tailwind classes primarily
- Leverage shadcn/ui design tokens
- Create custom CSS only when necessary
- Use `cn()` utility for conditional classes

#### 2. Component Styling Pattern

```typescript
import { cn } from "@/lib/utils";

interface ComponentProps {
  variant?: "default" | "outline" | "ghost";
  size?: "sm" | "md" | "lg";
  className?: string;
}

export function Component({
  variant = "default",
  size = "md",
  className,
}: ComponentProps) {
  return (
    <div
      className={cn(
        "base-styles",
        {
          "variant-styles": variant === "default",
          "size-styles": size === "md",
        },
        className
      )}
    >
      Content
    </div>
  );
}
```

### Error Handling Standards

#### 1. Error Boundaries

- Wrap route components in error boundaries
- Show user-friendly error messages
- Log errors for debugging

#### 2. Loading States

- Always show loading states for async operations
- Use skeleton components from shadcn/ui
- Provide feedback for user actions

### Form Handling Rules

#### 1. Use React Hook Form + Zod

```typescript
// lib/validations/case.ts
export const createCaseSchema = z.object({
  title: z.string().min(1, "Title is required"),
  description: z.string().optional(),
  clientId: z.string().min(1, "Client is required"),
});

// components/forms/case-form.tsx
export function CaseForm() {
  const form = useForm<CreateCaseData>({
    resolver: zodResolver(createCaseSchema),
  });

  // Form implementation
}
```

#### 2. Form Component Structure

- Separate form logic from UI
- Use shadcn/ui form components
- Include proper validation and error handling

### Testing Approach

#### 1. Component Testing

- Test component behavior, not implementation
- Use React Testing Library
- Focus on user interactions

#### 2. Integration Testing

- Test API integrations
- Test form submissions
- Test navigation flows

## 🚀 Quick Start Checklist for New Features

When creating a new feature:

1. **Plan the component hierarchy** - Break down into small components
2. **Define TypeScript types** - Create interfaces in `/types`
3. **Create API functions** - Add to `/lib/api`
4. **Build custom hooks** - Add to `/lib/hooks`
5. **Create validation schemas** - Add to `/lib/validations`
6. **Build UI components** - Start with smallest components first
7. **Add error handling** - Include loading and error states
8. **Test the feature** - Manual testing and basic unit tests

## 🔧 Development Commands

```bash
# Start development server
npm run dev

# Add new shadcn/ui component
npx shadcn-ui@latest add [component-name]

# Type checking
npm run type-check

# Linting
npm run lint
```

## 📝 Code Review Checklist

Before committing code, ensure:

- [ ] Components are small and managable
- [ ] All props have TypeScript interfaces
- [ ] Error handling is implemented
- [ ] Loading states are included
- [ ] Responsive design is considered
- [ ] Accessibility attributes are added
- [ ] No console.log statements remain
- [ ] Code follows naming conventions

## 🎨 Design System Usage

Always use shadcn/ui components as base:

- Buttons: Use `Button` component with variants
- Forms: Use `Form`, `FormField`, `FormItem` components
- Layout: Use `Card`, `Separator`, `Container` components
- Feedback: Use `Alert`, `Toast`, `Badge` components

## 🔄 State Management Patterns

### Global State (Zustand)

```typescript
// lib/stores/auth-store.ts
export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: (user) => set({ user }),
  logout: () => set({ user: null }),
}));
```

### Server State (React Query)

```typescript
// lib/hooks/use-cases.ts
export function useCases() {
  return useQuery({
    queryKey: ["cases"],
    queryFn: () => casesApi.getAll(),
  });
}
```

---

**Remember: These guidelines ensure consistency, maintainability, and scalability. Follow them strictly for all development work.**
