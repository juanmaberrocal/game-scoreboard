# frozen_string_literal: true

module Models
  # Shared Examples for Model classes
  # Includes specs that are reused by concern modules
  module SharedExamples
    # Specs for `WithStatus` Concern
    # Has tests for validation and scopes related to record statuses
    RSpec.shared_examples 'WithStatus Concern' do |klass_name, klass_column|
      context 'validations' do
        context 'result_status' do
          let(:pending_record) { create(klass_name, klass_column => :pending) }
          let(:confirmed_record) { create(klass_name, klass_column => :confirmed) }
          let(:rejected_record) { create(klass_name, klass_column => :rejected) }

          context 'updated to `confirmed`' do
            it 'succeeds if `pending`' do
              pending_record.update(klass_column => :confirmed)
              expect(pending_record.errors.include?(klass_column)).to eq(false)
            end

            it 'fails if not `pending`' do
              rejected_record.update(klass_column => :confirmed)
              expect(rejected_record.errors.include?(klass_column)).to eq(true)
            end
          end

          context 'updated to `rejected`' do
            it 'succeeds if `pending`' do
              pending_record.update(klass_column => :rejected)
              expect(pending_record.errors.include?(klass_column)).to eq(false)
            end

            it 'fails if not `pending`' do
              confirmed_record.update(klass_column => :rejected)
              expect(confirmed_record.errors.include?(klass_column)).to eq(true)
            end
          end

          it 'updated to `pending` fails' do
            confirmed_record.update(klass_column => :pending)
            expect(confirmed_record.errors.include?(klass_column)).to eq(true)
          end
        end
      end

      context 'scopes' do
        %i[pending confirmed rejected].each do |scope_status|
          it "filter by `result_status`=`#{scope_status}`" do
            klass = klass_name.to_s.classify.constantize

            scope_count = rand(1..5)
            unscope_status = scope_status == :pending ? :confirmed : :pending

            create_list(klass_name, scope_count, klass_column => scope_status)
            create_list(klass_name, rand(1..5), klass_column => unscope_status)

            expect(klass.send(scope_status).count).to eq(scope_count)
          end
        end
      end
    end
  end
end
