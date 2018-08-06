# frozen_string_literal: true

json.status @job.status
json.detailedStatus @job.detailed_status
json.errorMsg @job.error_msg
json.finished @job.finished?
json.error @job.error?

if @job.working?
  json.statusText t(".#{@job.detailed_status}")
else
  json.statusText t(".#{@job.status}")
end

if @job.finished?
  html = h(render('invoice_actions'))
  json.actionsHtml(html)
end
