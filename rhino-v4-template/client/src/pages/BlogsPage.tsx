import { useMemo, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useModelIndex, useModelStore, useModelDelete } from '@rhino-dev/rhino-react';
import type { Blog } from '../types';
import { Icon } from '../components/Icons';
import { useToast } from '../components/Toaster';
import { fmtRelative } from '../lib/format';
import { Loading } from './DashboardPage';

const PER_PAGE = 10;
type Sort = '-id' | 'title' | '-title' | 'created_at' | '-created_at';

export function BlogsPage() {
  const nav = useNavigate();
  const toast = useToast();
  const [search, setSearch] = useState('');
  const [publishedFilter, setPublishedFilter] = useState('');
  const [sort, setSort] = useState<Sort>('-created_at');
  const [page, setPage] = useState(1);
  const [showNew, setShowNew] = useState(false);

  const filters = useMemo(() => {
    const f: Record<string, any> = {};
    if (publishedFilter === 'true') f.published = true;
    if (publishedFilter === 'false') f.published = false;
    return f;
  }, [publishedFilter]);

  const blogs = useModelIndex<Blog>('blogs', {
    filters,
    search: search || undefined,
    sort,
    page,
    perPage: PER_PAGE,
  });

  const store = useModelStore<Blog>('blogs');
  const del = useModelDelete<Blog>('blogs');

  const list = blogs.data?.data ?? [];
  const pag = blogs.data?.pagination;

  function onSortClick(field: Exclude<Sort, `-${string}`>) {
    setSort(s => (s === field ? (`-${field}` as Sort) : field));
  }

  return (
    <>
      <div className="page-head">
        <div>
          <h1 className="page-title">Blogs</h1>
          <p className="page-sub">Multi-tenant scope: <span className="mono accent">/api/{`{org}`}/blogs</span></p>
        </div>
        <button className="btn btn-primary" onClick={() => setShowNew(true)}>
          <Icon.plus size={14} /> New blog
        </button>
      </div>

      <div className="toolbar">
        <input
          className="input input-search"
          style={{ flex: 1, maxWidth: 320 }}
          placeholder="Search title / body…"
          value={search}
          onChange={e => { setPage(1); setSearch(e.target.value); }}
        />
        <select
          className="input select"
          value={publishedFilter}
          onChange={e => { setPage(1); setPublishedFilter(e.target.value); }}
        >
          <option value="">All status</option>
          <option value="true">Published</option>
          <option value="false">Draft</option>
        </select>
        <span className="faint" style={{ marginLeft: 'auto', fontSize: 12 }}>
          {blogs.isFetching ? 'fetching…' : `${list.length} of ${pag?.total ?? list.length}`}
        </span>
      </div>

      <div className="card" style={{ overflow: 'visible' }}>
        {blogs.isLoading ? <Loading /> : list.length === 0 ? (
          <div className="empty">
            <h3>No blogs match</h3>
            <p>Try a different filter, or create one.</p>
          </div>
        ) : (
          <table className="table">
            <thead>
              <tr>
                <Th label="Title" field="title" sort={sort} onClick={onSortClick} />
                <th>Status</th>
                <Th label="Created" field="created_at" sort={sort} onClick={onSortClick} />
                <th style={{ width: 60 }}></th>
              </tr>
            </thead>
            <tbody>
              {list.map(b => (
                <tr key={b.id} onClick={() => nav(`/blogs/${b.id}`)}>
                  <td>
                    <Link to={`/blogs/${b.id}`} onClick={e => e.stopPropagation()} style={{ fontWeight: 600 }}>
                      {b.title || 'Untitled'}
                    </Link>
                    <div className="faint" style={{ fontSize: 11, marginTop: 2 }}>
                      {b.body?.slice(0, 90)}
                      {b.body && b.body.length > 90 ? '...' : ''}
                    </div>
                  </td>
                  <td>
                    <span className={`pill ${b.published ? 'pill-active' : 'pill-draft'}`}>
                      {b.published ? 'Published' : 'Draft'}
                    </span>
                  </td>
                  <td className="faint">{fmtRelative(b.created_at)}</td>
                  <td>
                    <button
                      className="btn btn-ghost btn-icon"
                      title="Soft delete (move to trash)"
                      onClick={async e => {
                        e.stopPropagation();
                        if (!confirm(`Delete blog "${b.title || 'Untitled'}"?`)) return;
                        try {
                          await del.mutateAsync(b.id);
                          toast(`Deleted "${b.title || 'Untitled'}"`, 'ok');
                        } catch (err) {
                          toast(`Delete failed: ${(err as Error).message}`, 'error');
                        }
                      }}
                    >
                      <Icon.trash size={14} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}

        {pag && pag.lastPage > 1 && (
          <div className="pager">
            <div className="pager-info">Page {pag.currentPage} of {pag.lastPage} · {pag.total} total</div>
            <div className="pager-ctrls">
              <button className="btn btn-sm" disabled={page <= 1} onClick={() => setPage(p => p - 1)}>
                <Icon.arrowL size={12} />
              </button>
              <button className="btn btn-sm" disabled={page >= pag.lastPage} onClick={() => setPage(p => p + 1)}>
                <Icon.arrowR size={12} />
              </button>
            </div>
          </div>
        )}
      </div>

      {showNew && (
        <NewBlogModal
          onClose={() => setShowNew(false)}
          onCreate={async data => {
            try {
              const created = await store.mutateAsync(data);
              toast(`Created "${created.title || 'Untitled'}"`, 'ok');
              setShowNew(false);
            } catch (err) {
              toast(`Create failed: ${(err as Error).message}`, 'error');
            }
          }}
          busy={store.isPending}
        />
      )}
    </>
  );
}

function Th(props: { label: string; field: string | null; sort?: string; onClick?: (f: any) => void }) {
  const { label, field, sort, onClick } = props;
  if (!field || !onClick) return <th>{label}</th>;
  const active = sort === field || sort === `-${field}`;
  return (
    <th className={active ? 'sorted' : ''} onClick={() => onClick(field)}>
      {label}
      <span className="sort-arrow">{active ? (sort === field ? '↑' : '↓') : '↕'}</span>
    </th>
  );
}

function NewBlogModal({ onClose, onCreate, busy }: { onClose: () => void; onCreate: (data: Partial<Blog>) => Promise<void>; busy: boolean }) {
  const [title, setTitle] = useState('');
  const [body, setBody] = useState('');
  const [published, setPublished] = useState(false);

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal" onClick={e => e.stopPropagation()}>
        <div className="modal-head">
          <div className="modal-title">New blog</div>
          <button className="btn btn-ghost btn-icon" onClick={onClose}><Icon.close /></button>
        </div>
        <div className="modal-body">
          <form className="form" onSubmit={e => { e.preventDefault(); onCreate({ title, body, published }); }}>
            <div className="field">
              <label>Title</label>
              <input className="input" value={title} onChange={e => setTitle(e.target.value)} required autoFocus />
            </div>
            <div className="field">
              <label>Body</label>
              <textarea className="input" rows={6} value={body} onChange={e => setBody(e.target.value)} required />
            </div>
            <div className="field-row" style={{ display: 'flex', alignItems: 'center', gap: 8, margin: '12px 0' }}>
              <input
                type="checkbox"
                id="published"
                checked={published}
                onChange={e => setPublished(e.target.checked)}
              />
              <label htmlFor="published" style={{ margin: 0, cursor: 'pointer' }}>Publish immediately</label>
            </div>
            <div className="modal-foot" style={{ padding: 0, border: 0 }}>
              <button type="button" className="btn btn-ghost" onClick={onClose}>Cancel</button>
              <button type="submit" className="btn btn-primary" disabled={busy}>
                {busy ? <span className="spinner" /> : <Icon.check size={14} />} Create
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
