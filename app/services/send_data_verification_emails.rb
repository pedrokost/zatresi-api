#!/usr/bin/ruby
# @Author: Pedro Kostelec
# @Date:   2017-01-07 21:23:02
# @Last Modified by:   Pedro Kostelec
# @Last Modified time: 2017-01-14 18:14:51

class SendDataVerificationEmails
  # Sends email to klub owners who have not verified their klub data for a
  # while

  def call
    begin
      klubs_to_email = awaiting_klubs

      Rails.logger.info "Will send #{klubs_to_email.count} emails for data verification"
      klubs_to_email.each do |klub|
        Rails.logger.info "Sending data verification request email to #{klub.email} for klub #{klub.name}"
        klub.send_request_verify_klub_data_mail
      end
    rescue Exception => e
      Rails.logger.error e
      Raygun.track_exception(e)
    end
  end

  def awaiting_klubs
    # Ordered list of klubs to receive the the notification
    threshold_date = ENV['REQUIRE_NEW_VERIFICATION_AFTER'].to_i.days.ago
    supported_categories = ENV['SUPPORTED_CATEGORIES'].split ','

    Klub.where('last_verification_reminder_at IS NULL OR last_verification_reminder_at < ?', threshold_date)
      .where(verified: true)
      .where('ARRAY[?]::varchar[] && categories', supported_categories)
      .where(parent: nil)
      .where.not(email: [nil, ''])
      .order('last_verification_reminder_at ASC NULLS FIRST, created_at ASC')
      .limit(ENV['NUM_DAILY_DATA_VERIFICATION_EMAILS'])
  end
end