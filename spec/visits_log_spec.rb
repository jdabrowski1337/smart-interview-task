# frozen_string_literal: true

require 'spec_helper'
require_relative '../app/visits_log'

describe VisitsLog do
  let!(:visits_log) { VisitsLog.new }
  let!(:example_path) { 'some/path' }
  let!(:example_ip) { '1.2.3.4' }

  describe '#log_visit' do
    subject { visits_log.log_visit(path: example_path, ip: example_ip) }

    it 'should add a new visit' do
      expect { subject }.to change { visits_log.website_visits(example_path).size }.by(1)
    end
  end

  describe '#initialize' do
    subject { VisitsLog.new('./spec/fixtures/example.log') }

    it 'should load visits logs from input file' do
      expect(subject.websites.size).to eq 3
      expect(subject.website_visits('/about/2').size).to eq 2
    end

    context 'with incorrect input file path' do
      subject { VisitsLog.new('fixtures/file-that-does-not-exist.log') }

      it 'should raise WebsitesLogError' do
        expect{subject}.to raise_error VisitsLogError
      end
    end
  end

  context 'with an example set of visits' do
    before do
      visits_log.clear
      visits_log.log_visit(path: 'path1', ip: '1.1.1.1')
      visits_log.log_visit(path: 'path1', ip: '1.1.1.2')
      3.times do
        visits_log.log_visit(path: 'path2', ip: '1.1.1.3')
      end
    end

    describe '#website_visits' do
      subject { visits_log.website_visits('path1') }

      it 'should return all logged visits for the specific website' do
        expect(subject).to match_array %w[1.1.1.1 1.1.1.2]
      end
    end

    describe '#websites' do
      subject { visits_log.websites }

      it 'should return a list of all unique website paths' do
        expect(subject).to match_array %w[path1 path2]
      end
    end

    describe '#clear' do
      subject { visits_log.clear }
      it 'should remove all logged websites and their visits' do
        expect { subject }.to change { visits_log.websites.size }.to 0
      end
    end

    describe '#most_unique_visits' do
      subject { visits_log.most_unique_visits }

      it 'should return an entry for each logged website path' do
        expect(subject.size).to eq 2
      end

      it 'should return the website path with most unique visits first' do
        expect(subject[0][:path]).to eq 'path1'
      end
    end

    describe '#most_visits' do
      subject { visits_log.most_visits }

      it 'should return an entry for each logged website path' do
        expect(subject.size).to eq 2
      end

      it 'should return the website path with most visits first' do
        expect(subject[0][:path]).to eq 'path2'
      end

    end
  end
end
