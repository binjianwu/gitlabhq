require 'spec_helper'

describe Gitlab::Ci::Status::External::Common do
  let(:user) { create(:user) }
  let(:project) { external_status.project }
  let(:external_target_url) { 'http://example.gitlab.com/status' }

  let(:external_status) do
    create(:generic_commit_status, target_url: external_target_url)
  end

  subject do
    Gitlab::Ci::Status::Core
      .new(external_status, user)
      .extend(described_class)
  end

  describe '#has_action?' do
    it { is_expected.not_to have_action }
  end

  describe '#has_details?' do
    context 'when user has access to read commit status' do
      before { project.team << [user, :developer] }

      it { is_expected.to have_details }
    end

    context 'when user does not have access to read commit status' do
      it { is_expected.not_to have_details }
    end
  end

  describe '#details_path' do
    it 'links to the external target URL' do
      expect(subject.details_path).to eq external_target_url
    end
  end
end
