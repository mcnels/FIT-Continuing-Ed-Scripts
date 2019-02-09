#!/usr/bin/env ruby
require 'canvas-api'
require 'json'
require 'axlsx'
require 'date'

canvas = Canvas::API.new(:host => "https://fit.instructure.com", :token => "1059~c5Bnm7yge4gSWfeOJ9ZRtWCpGbUPwDkRQzXgV20CeMcA1j9wvEpXvlMrF3x9onyD")

submInfo = Array.new
# precourse survey submission date
quiz_subm = canvas.get("/api/v1/courses/533396/quizzes/826643/submissions?", {'per_page' => '100'})

# Get all the quizzes
while quiz_subm.more? do
  quiz_subm.next_page!
end

list_student = canvas.get("/api/v1/courses/533396/enrollments", {'type' =>'StudentEnrollment'})
while list_student.more? do
  list_student.next_page!
end

students = Array.new(list_student)
list = Array.new
noSubm = Array.new

students.each do |stu|
  taken = false

  quiz_subm.each do |submission|

    # if submission['finished_at'] != "null"
      if stu['user_id'] == submission['user_id']
        taken = true
        # puts stu['user']['name'].to_s
        list.push(:enroll => stu['id'], :id => stu['user_id'], :name => stu['user']['name'], :invDate => stu['created_at'], :status => stu['enrollment_state'], :submDate => submission['finished_at'].to_s)

      end
      break if taken

  end

  if taken == false
    noSubm.push(:enroll => stu['id'], :name => stu['user']['name'], :invDate => stu['created_at'], :status => stu['enrollment_state'])
  end

end

noSubm.uniq! { |ex| ex[:name] }

#test
puts list.length
puts list
puts "------------------------------------------------------------------------------------------------------"
puts noSubm.length
puts noSubm
puts "------------------------------------------------------------------------------------------------------"

# Get deactivation list
deactivation = Array.new
noSubm.each do |li|
  if (Date.today - DateTime.parse(li[:invDate].to_s).to_date) >= 30
    deactivation.push(:enroll => li[:enroll], :name => li[:name], :status => li[:status], :days => (Date.today - DateTime.parse(li[:invDate].to_s).to_date))
  end
end

#test
puts deactivation.length
puts deactivation
puts "------------------------------------------------------------------------------------------------------"

# Add message to send to students down below
# message2 = "Hello, \n"+"\n"
# message2 += "Unfortunately, your access to the RBT Essentials course has expired. You did not begin the training within the allotted timeframe, therefore you have been automatically disenrolled from the training and will not be reimbursed the paid enrollment fee.\n"+"\n"
# message2 += "To reregister for the RBT Essentials course, please visit https://register.fit.edu/jsp/index.jsp and click on Applied Behavior Analysis under HOME SUB-CATEGORIES; then select the date range under Registered Behavior Technician Training.\n"+ "\n"
# message2 += "Please let us know if you have any questions or concerns. You can contact us by emailing abareg@fit.edu or calling 1-321-674-8382, option 2. We're available by phone from 9:00 AM to 5:00 PM Eastern time Monday through Friday, excluding university holidays.\n" + "\n"

isDeactivated = false

deactConfirm = ""
deactivation.each do |deact|
  if deact[:status].to_s == "active"
    canvas.delete("/api/v1/courses/533396/enrollments/" + deact[:enroll].to_s, {'task' =>'inactivate'})
    isDeactivated = true

    # send deactivation message to student
    # canvas.post("/api/v1/conversations", {'recipients[]' => deact[:id].to_s, 'subject' =>'Important: Your Access to RBT Essentials Has Expired', 'body' => message2, "group_conversation" => true, "bulk_message" => true})

    deactConfirm = deactConfirm + deact[:name].to_s + " has been deactivated.\n"
    puts deact[:name].to_s + "has been deactivated and notified."
  end
end

# send message to abareg, Jenn, Stephanie, Theresa and Marisell
canvas.post("/api/v1/conversations", {'recipients[]' => '1010887', 'subject' =>'RBT Idaho Deactivations', 'body' => deactConfirm, "group_conversation" => true, "bulk_message" => true}) #abareg
canvas.post("/api/v1/conversations", {'recipients[]' => '1842270', 'subject' =>'RBT Idaho Deactivations', 'body' => deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Stephanie
canvas.post("/api/v1/conversations", {'recipients[]' => '1874990', 'subject' =>'RBT Idaho Deactivations', 'body' => deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Jenn
canvas.post("/api/v1/conversations", {'recipients[]' => '1873108', 'subject' =>'RBT Idaho Deactivations', 'body' => deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Marisell

if isDeactivated == false
  canvas.post("/api/v1/conversations", {'recipients[]' => '777482', 'subject' =>'RBT Idaho Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT Idaho today!", "group_conversation" => true, "bulk_message" => true}) #Theresa
  canvas.post("/api/v1/conversations", {'recipients[]' => '1842270', 'subject' =>'RBT Idaho Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT Idaho today!", "group_conversation" => true, "bulk_message" => true}) #Stephanie
  canvas.post("/api/v1/conversations", {'recipients[]' => '1874990', 'subject' =>'RBT Idaho Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT Idaho today!", "group_conversation" => true, "bulk_message" => true}) #Jenn
  canvas.post("/api/v1/conversations", {'recipients[]' => '1873108', 'subject' =>'RBT Idaho Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT Idaho today!", "group_conversation" => true, "bulk_message" => true}) #Marisell
  puts "No deactivations today!"
end

puts "------------------------------------------------------------------------------------------------------"
puts "All done!"
