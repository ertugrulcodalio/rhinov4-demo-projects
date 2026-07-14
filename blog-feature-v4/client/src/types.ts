// Re-export the Rhino-generated model schemas as friendly, fully-required types.
// The generator emits everything as optional (`field?:`) because the source is
// an OpenAPI-ish schema; we tighten them here for nicer DX on the consumer side.
import type { components } from './types/rhino.d.ts';

type Required<T> = { [K in keyof T]-?: T[K] };

export type Organization = Required<components['schemas']['Organization']>;
export type Role         = Required<components['schemas']['Role']>;
export type Blog         = Required<components['schemas']['Blog']>;
export interface User {
  id: number;
  name: string;
  email: string;
  created_at: string;
  updated_at: string;
}
export interface UserRole {
  id: number;
  user_id: number;
  role_id: number;
  organization_id: number;
  created_at: string;
  updated_at: string;
}

// Permission slug type — blog-feature-v4 only has blogs resource.
export type ResourceSlug = 'blogs' | 'users';
export type ActionSlug   = 'index' | 'show' | 'store' | 'update' | 'destroy' | 'trashed' | 'restore' | 'force-delete';
export type PermissionSlug = `${ResourceSlug}.${ActionSlug}` | '*' | `${ResourceSlug}.*`;
