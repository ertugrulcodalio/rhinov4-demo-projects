import { useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { useModelShow, useModelUpdate, useModelDelete } from '@rhino-dev/rhino-react';
import type { Blog } from '../types';
import { Icon } from '../components/Icons';
import { useToast } from '../components/Toaster';
import { fmtDate, fmtRelative } from '../lib/format';
import { Loading } from './DashboardPage';

export function BlogDetailPage() {
  const { id } = useParams<{ id: string }>();
  const nav = useNavigate();
  const toast = useToast();
  const blog = useModelShow<Blog>('blogs', id);
  const update = useModelUpdate<Blog>('blogs');
  const del = useModelDelete<Blog>('blogs');

  const [editing, setEditing] = useState(false);

  if (blog.isLoading) return <Loading />;
  const b = blog.data;
  if (blog.error || !b) return <div className="empty"><h3>Not found</h3><p>This blog may have been deleted.</p></div>;

  return (
    <>
      <div className="page-head">
        <div>
          <div className="row" style={{ marginBottom: 4 }}>
            <Link to="/blogs" className="btn btn-ghost btn-sm"><Icon.arrowL size={12} /> Back</Link>
            <span className={`pill ${b.published ? 'pill-active' : 'pill-draft'}`}>
              {b.published ? 'Published' : 'Draft'}
            </span>
          </div>
          <h1 className="page-title">{b.title || 'Untitled'}</h1>
        </div>
        <div className="row">
          <button className="btn" onClick={() => setEditing(true)}><Icon.edit size={14} /> Edit</button>
          <button
            className="btn btn-danger"
            onClick={async () => {
              if (!confirm(`Delete blog "${b.title || 'Untitled'}"?`)) return;
              await del.mutateAsync(b.id);
              toast('Blog moved to trash', 'ok');
              nav('/blogs');
            }}
          ><Icon.trash size={14} /> Delete</button>
        </div>
      </div>

      <div className="detail-grid">
        <div>
          <div className="card" style={{ padding: 24 }}>
            <div style={{ whiteSpace: 'pre-wrap', fontSize: 15, lineHeight: 1.6 }}>
              {b.body || <span className="faint">No content</span>}
            </div>
          </div>
        </div>

        <aside>
          <div className="card">
            <div className="card-header"><div className="card-title">Blog details</div></div>
            <div className="card-body">
              <dl className="kv">
                <dt>ID</dt><dd className="mono">{b.id}</dd>
                <dt>Org</dt><dd className="mono">#{b.organization_id}</dd>
                <dt>Status</dt>
                <dd>
                  <span className={`pill ${b.published ? 'pill-active' : 'pill-draft'}`}>
                    {b.published ? 'Published' : 'Draft'}
                  </span>
                </dd>
                <dt>Created</dt><dd className="muted">{fmtDate(b.created_at)}</dd>
                <dt>Updated</dt><dd className="muted">{fmtRelative(b.updated_at)}</dd>
              </dl>
            </div>
          </div>
        </aside>
      </div>

      {editing && (
        <EditBlogModal
          blog={b}
          busy={update.isPending}
          onClose={() => setEditing(false)}
          onSave={async data => {
            try {
              await update.mutateAsync({ id: b.id, data });
              toast('Blog updated', 'ok');
              setEditing(false);
            } catch (err) {
              toast(`Update failed: ${(err as Error).message}`, 'error');
            }
          }}
        />
      )}
    </>
  );
}

function EditBlogModal({ blog, onClose, onSave, busy }: { blog: Blog; onClose: () => void; onSave: (data: Partial<Blog>) => Promise<void>; busy: boolean }) {
  const [title, setTitle] = useState(blog.title || '');
  const [body, setBody] = useState(blog.body || '');
  const [published, setPublished] = useState(blog.published || false);

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal" onClick={e => e.stopPropagation()}>
        <div className="modal-head">
          <div className="modal-title">Edit blog</div>
          <button className="btn btn-ghost btn-icon" onClick={onClose}><Icon.close /></button>
        </div>
        <div className="modal-body">
          <form className="form" onSubmit={e => { e.preventDefault(); onSave({ title, body, published }); }}>
            <div className="field">
              <label>Title</label>
              <input className="input" value={title} onChange={e => setTitle(e.target.value)} required />
            </div>
            <div className="field">
              <label>Body</label>
              <textarea className="input" rows={8} value={body} onChange={e => setBody(e.target.value)} required />
            </div>
            <div className="field-row" style={{ display: 'flex', alignItems: 'center', gap: 8, margin: '12px 0' }}>
              <input
                type="checkbox"
                id="published"
                checked={published}
                onChange={e => setPublished(e.target.checked)}
              />
              <label htmlFor="published" style={{ margin: 0, cursor: 'pointer' }}>Published</label>
            </div>
            <div className="modal-foot" style={{ padding: 0, border: 0 }}>
              <button type="button" className="btn btn-ghost" onClick={onClose}>Cancel</button>
              <button type="submit" className="btn btn-primary" disabled={busy}>
                {busy ? <span className="spinner" /> : <Icon.check size={14} />} Save
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
