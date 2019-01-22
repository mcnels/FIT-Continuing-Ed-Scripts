#!/usr/bin/env ruby
require 'canvas-api'
require 'json'
require 'axlsx'
require 'date'

canvas = Canvas::API.new(:host => "https://fit.instructure.com", :token => "1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj")

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

deactivation.each do |deact|
  if deact[:status].to_s == "active"
    canvas.delete("/api/v1/courses/533396/enrollments/" + deact[:enroll].to_s, {'task' =>'inactivate'})
    puts deact[:name].to_s + " deactivated!"
  end
end

puts "All done!"
