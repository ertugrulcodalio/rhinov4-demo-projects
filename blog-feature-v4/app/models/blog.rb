# frozen_string_literal: true

class Blog < Rhino::RhinoModel
  include Rhino::BelongsToOrganization
  include Discard::Model

  # BelongsToOrganization defines .for_organization(org) as a class method.
  # Rhino's scope_to_organization calls it on the bare class (not the current
  # relation), which resets the scope chain and loses Discard's discarded_at
  # condition on the /trashed endpoint. Removing it makes scope_to_organization
  # fall back to relation.where(organization_id:) which chains correctly.
  singleton_class.undef_method(:for_organization)

  rhino_fields :id, :title, :body, :published, :discarded_at, :created_at, :updated_at
  rhino_filters :title, :published
  rhino_sorts :title, :published, :created_at
  validates :title, length: { maximum: 255 }, allow_nil: true
  validates :published, inclusion: { in: [true, false] }, allow_nil: true
end
