class AMQPConfig
  class <<self
    def data
      @data ||= Hashie::Mash.new YAML.load_file(Rails.root.join('config', 'amqp.yml'))
    end

    def connect
      data[:connect]
    end

    def binding_exchange_id(id)
      puts 'binding exchange_id'
      puts data[:binding]
      data[:binding][id][:exchange]
    end

    def binding_exchange(id)
      puts 'binding exchange'
      eid = binding_exchange_id(id)
      eid && exchange(eid)
    end

    def binding_queue(id)
      puts 'binding queue'
      queue data[:binding][id][:queue]
    end

    def binding_worker(id)
      ::Worker.const_get(id.to_s.camelize).new
    end

    def routing_key(id)
      binding_queue(id).first
    end

    def topics(id)
      data[:binding][id][:topics].split(',')
    end

    def channel(id)
      (data[:channel] && data[:channel][id]) || {}
    end

    def queue(id)
      name = data[:queue][id][:name]
      settings = { durable: data[:queue][id][:durable] }
      [name, settings]
    end

    def exchange(id)
      puts 'id'
      puts id
      puts data[:exchange]
      type = data[:exchange][id][:type]
      name = data[:exchange][id][:name]
      [type, name]
    end

  end
end
