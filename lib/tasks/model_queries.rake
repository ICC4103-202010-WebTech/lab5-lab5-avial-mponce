namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end
  task :model_queries => :environment do
    puts("Query 1: numbers of tickets by a given customer")
    r = Customer.find(5).tickets.count
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 2: Total number of different events that a given customer has attended")
    r = Event.joins(ticket_types: {tickets: :order}).where(orders: {customer_id: 1}).select(:name).distinct.count
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 3: name of events attended by customer")
    r = Event.joins(ticket_types: {tickets: :order}).where(orders: {customer_id: 1}).select(:name).distinct.pluck(:name)
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 4: Total number of tickets sold for an event")
    r = Ticket.joins(ticket_type: :event).where(events: {id: 1}).count
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 5: Total sales of an event")
    r = Event.joins(ticket_types: :tickets).where(id: '1').sum(:ticket_price)
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 6: The event that has been most attended by women")
    r = Event.joins(ticket_types: {tickets: {order: :customer}}).where(customers: {gender: "f"}).group(:id).count.max
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 7:  The event that has been most attended by men ages 18 to 30")
    r = Customer.joins(tickets: [ticket_type: :event]).where("gender = 'm' and age >= 18 and age<=30").group('events.name').count.max
    puts(r)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end
end