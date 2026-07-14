import { useAuth } from '@rhino-dev/rhino-react';
import { Routes, Route, Navigate } from 'react-router-dom';

import { LoginPage } from './pages/LoginPage';
import { AppShell } from './components/AppShell';
import { TrashPage } from './pages/TrashPage';
import { MembersPage } from './pages/MembersPage';
import { DashboardPage } from './pages/DashboardPage';
import { BlogsPage } from './pages/BlogsPage';
import { BlogDetailPage } from './pages/BlogDetailPage';

export function App() {
  const { isAuthenticated } = useAuth();

  if (!isAuthenticated) {
    return (
      <Routes>
        <Route path="*" element={<LoginPage />} />
      </Routes>
    );
  }

  return (
    <AppShell>
      <Routes>
        <Route path="/" element={<Navigate to="/dashboard" replace />} />
        <Route path="/dashboard" element={<DashboardPage />} />
        <Route path="/blogs" element={<BlogsPage />} />
        <Route path="/blogs/:id" element={<BlogDetailPage />} />
        <Route path="/trash" element={<TrashPage />} />
        <Route path="/members" element={<MembersPage />} />
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </AppShell>
  );
}
