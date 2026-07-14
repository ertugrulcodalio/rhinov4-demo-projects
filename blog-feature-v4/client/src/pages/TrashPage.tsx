import { useModelTrashed, useModelRestore, useModelForceDelete } from '@rhino-dev/rhino-react';
import type { Blog } from '../types';
import { Icon } from '../components/Icons';
import { useToast } from '../components/Toaster';
import { fmtRelative } from '../lib/format';
import { Loading } from './DashboardPage';

export function TrashPage() {
  const toast   = useToast();
  const trashed = useModelTrashed<Blog>('blogs');
  const restore = useModelRestore<Blog>('blogs');
  const fdel    = useModelForceDelete<Blog>('blogs');
  const list    = trashed.data?.data ?? [];

  return (
    <>
      <div className="page-head">
        <div>
          <h1 className="page-title">Trash</h1>
          <p className="page-sub">Soft-deleted blogs — restore or permanently delete</p>
        </div>
      </div>

      {trashed.isLoading ? <Loading /> : list.length === 0 ? (
        <div className="empty">
          <h3>Trash is empty</h3>
          <p>Soft-deleted blogs will appear here for restore or permanent deletion.</p>
        </div>
      ) : (
        <div className="card">
          <table className="table">
            <thead>
              <tr>
                <th>Title</th>
                <th>Published</th>
                <th>Deleted</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {list.map(blog => (
                <tr key={blog.id} className="deleted">
                  <td style={{ fontWeight: 500 }}>{blog.title}</td>
                  <td>
                    <span className={`pill pill-${blog.published ? 'active' : 'draft'}`}>
                      <span className="pill-dot" />{blog.published ? 'published' : 'draft'}
                    </span>
                  </td>
                  <td className="faint">{fmtRelative(blog.discarded_at)}</td>
                  <td>
                    <div className="row gap-2" style={{ justifyContent: 'end' }}>
                      <button
                        className="btn btn-sm"
                        onClick={async () => { await restore.mutateAsync(blog.id); toast('Blog restored', 'ok'); }}
                      >
                        <Icon.restore size={12} /> Restore
                      </button>
                      <button
                        className="btn btn-sm btn-danger"
                        onClick={async () => {
                          if (confirm('Permanently delete this blog? This cannot be undone.')) {
                            await fdel.mutateAsync(blog.id);
                            toast('Permanently deleted', 'ok');
                          }
                        }}
                      >
                        <Icon.trash size={12} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
}
