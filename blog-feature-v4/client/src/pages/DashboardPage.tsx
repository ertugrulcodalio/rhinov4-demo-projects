import { useModelIndex, useModelTrashed } from '@rhino-dev/rhino-react';
import { Link } from 'react-router-dom';
import type { Blog } from '../types';
import { Icon } from '../components/Icons';
import { fmtRelative } from '../lib/format';

export function DashboardPage() {
  const blogs      = useModelIndex<Blog>('blogs', { perPage: 100 });
  const trashBlogs = useModelTrashed<Blog>('blogs');

  const blogList   = blogs.data?.data ?? [];
  const trashCount = trashBlogs.data?.data?.length ?? 0;

  const publishedCount   = blogList.filter(b => b.published).length;
  const unpublishedCount = blogList.filter(b => !b.published).length;

  return (
    <>
      <div className="page-head">
        <div>
          <h1 className="page-title">Dashboard</h1>
          <p className="page-sub">Overview of your blog activity</p>
        </div>
        <Link className="btn btn-primary" to="/blogs">
          <Icon.edit size={14} /> Manage Blogs
        </Link>
      </div>

      <div className="stats">
        <Stat label="Total blogs"   value={blogList.length}    hint="all posts" />
        <Stat label="Published"     value={publishedCount}     hint="live posts" />
        <Stat label="Drafts"        value={unpublishedCount}   hint="unpublished" />
        <Stat label="In trash"      value={trashCount}         hint="restorable" />
      </div>

      <div className="detail-grid">
        <div className="card">
          <div className="card-header">
            <div className="card-title">Recent blogs</div>
            <Link className="btn btn-ghost btn-sm" to="/blogs">View all <Icon.arrowR size={12} /></Link>
          </div>
          {blogs.isLoading ? <Loading /> : (
            <table className="table">
              <thead><tr><th>Title</th><th>Status</th><th>Updated</th></tr></thead>
              <tbody>
                {blogList.slice(0, 8).map(b => (
                  <tr key={b.id}>
                    <td>
                      <Link to={`/blogs/${b.id}`} style={{ fontWeight: 600 }}>{b.title}</Link>
                      <div className="faint" style={{ fontSize: 12 }}>{b.body?.slice(0, 60)}</div>
                    </td>
                    <td>
                      <span className={`pill pill-${b.published ? 'active' : 'draft'}`}>
                        <span className="pill-dot" />{b.published ? 'published' : 'draft'}
                      </span>
                    </td>
                    <td className="faint">{fmtRelative(b.updated_at)}</td>
                  </tr>
                ))}
                {blogList.length === 0 && <tr><td colSpan={3} className="card-empty">No blogs yet. <Link to="/blogs">Create one →</Link></td></tr>}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </>
  );
}

function Stat({ label, value, hint }: { label: string; value: number; hint?: string }) {
  return (
    <div className="stat">
      <div className="stat-label">{label}</div>
      <div className="stat-value">{value}</div>
      {hint && <div className="stat-hint">{hint}</div>}
    </div>
  );
}

export function StatusPill({ value }: { value: string }) {
  return <span className={`pill pill-${value}`}><span className="pill-dot" />{value.replace('_', ' ')}</span>;
}

export function PriorityPill({ value }: { value: string }) {
  return <span className={`pill pill-${value}`}>{value}</span>;
}

export function Loading() {
  return <div className="loading"><span className="spinner" /> Loading…</div>;
}
