module RailsCom::AttachedOne

  def attachment
    if super
      return super
    elsif defined?(@attachment)
      return @attachment
    end

    id = ActiveStorage::BlobDefault.defaults["#{record.class.name}_#{name}"]
    @attachment = ActiveStorage::Attachment.new(record: record, name: name, blob: ActiveStorage::Blob.find(id)) if id
  end

  def attached?
    attachment&.id?
  end

  def present?
    attachment.present?
  end

end

ActiveStorage::Attached::One.prepend RailsCom::AttachedOne
