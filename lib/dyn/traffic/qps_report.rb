module Dyn
  module Traffic
    class QPSReport
      attr_accessor :csv

      def initialize(dyn, csv)
        @dyn = dyn
        @csv = csv
      end

      def csv()
        value ? (@csv = value; self) : @csv
      end

      def resource_path
        "QPSReport"
      end

      def create(csv)
        @dyn.create("#{resource_path}")
      end

      def to_json
        {
          "csv" => @csv,
        }.to_json
      end
    end
  end
end
