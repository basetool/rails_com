# frozen_string_literal: true
module RailsCom::FormatHelper

  def simple_format_hash(hash_text, html_options = {}, options = {})
    wrapper_tag = options.fetch(:wrapper_tag, :p)

    hash_text.map do |k, v|
      if k.to_s.rstrip.end_with?(':')
        text = k.to_s + ' ' + v.to_s
      else
        text = k.to_s + ': ' + v.to_s
      end

      content_tag(wrapper_tag, text, html_options)
    end.join("\n\n").html_safe
  end

  def simple_format(text, html_options = {}, options = {})
    if text.is_a?(Hash)
      return simple_format_hash(text, html_options, options)
    end

    if text.is_a?(Array)
      begin
        hash_text = text.to_h
        return simple_format_hash(hash_text, html_options, options)
      rescue TypeError
        return text.map { |t| content_tag(:p, t, html_options) }.join("\n").html_safe
      end
    end

    text = text.to_s

    super
  end

end
