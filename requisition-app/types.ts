// ============================================================
// Kama Companies – Requisition System Types
// (Reference TypeScript definitions – the live app is pure JS)
// ============================================================

/** Company departments */
export type Department =
  | "Sales"
  | "R and D"
  | "Executive"
  | "Engineering"
  | "Finance";

/** Expense / request categories */
export type RequestCategory =
  | "Food expenses"
  | "Human resources"
  | "Sales and marketing"
  | "Technology and hosting"
  | "Fuel and transport"
  | "Others";

export type RequestType =
  | "Purchase requisition"
  | "Leave request"
  | "Equipment / asset request"
  | "Travel expense";

/** Request priority levels */
export type Priority = "Normal" | "High" | "Urgent";

/** Request workflow status */
export type RequestStatus =
  | "pending"
  | "pending_manager"
  | "pending_finance"
  | "needs_revision"
  | "approved"
  | "rejected";

/** User roles in the system */
export type UserRole = "employee" | "manager" | "admin";

/** Calendar event types */
export type EventType = "activity" | "leave" | "meeting" | "other";

/** Allowed categories for each department */
export type DepartmentCategoryMap = Record<Department, readonly RequestCategory[]>;

export const DEPT_CATEGORY_MAP: DepartmentCategoryMap = {
  Sales: [
    "Sales and marketing",
    "Food expenses",
    "Fuel and transport",
    "Others",
  ],
  "R and D": [
    "Technology and hosting",
    "Human resources",
    "Fuel and transport",
    "Others",
  ],
  Executive: [
    "Food expenses",
    "Human resources",
    "Sales and marketing",
    "Technology and hosting",
    "Fuel and transport",
    "Others",
  ],
  Engineering: [
    "Technology and hosting",
    "Fuel and transport",
    "Human resources",
    "Others",
  ],
  Finance: [
    "Food expenses",
    "Human resources",
    "Sales and marketing",
    "Technology and hosting",
    "Fuel and transport",
    "Others",
  ],
} as const;

export interface User {
  id: string;
  username: string;
  name: string;
  dept: Department;
  role: UserRole;
}

export interface LocalAccount extends User {
  passwordSalt: string;
  passwordHash: string;
}

export interface Requisition {
  id: string;
  type: RequestCategory | RequestType;
  priority: Priority;
  title: string;
  details: string;
  quantity?: string;
  estimatedCost?: string;
  typeDetails?: Record<string, string>;
  neededBy?: string;
  attachmentNotes?: string;
  attachments?: Array<{
    name: string;
    type: string;
    size: number;
    data: string;
  }>;
  requester: string;
  department: Department;
  status: RequestStatus;
  createdAt: string;
  requesterId?: string;
  history?: Array<{
    status: RequestStatus;
    actor: string;
    at: string;
    comment?: string;
  }>;
  actionComment?: string;
  actionBy?: string;
  actionAt?: string;
}

export interface CalendarEvent {
  id: string;
  title: string;
  date: string;
  type: EventType;
  description?: string;
  createdBy: string;
  createdAt: string;
}

export interface ValidationResult {
  valid: boolean;
  message: string;
}

export function validateDepartmentCategory(
  department: Department,
  category: RequestCategory
): ValidationResult {
  const allowed = DEPT_CATEGORY_MAP[department];
  if (!allowed) {
    return { valid: false, message: `Unknown department: ${department}` };
  }
  if (!allowed.includes(category)) {
    return {
      valid: false,
      message: `"${category}" is not allowed for the ${department} department. Allowed: ${allowed.join(", ")}`,
    };
  }
  return { valid: true, message: "OK" };
}

export function getAllowedCategories(department: Department): readonly RequestCategory[] {
  return DEPT_CATEGORY_MAP[department] ?? [];
}
