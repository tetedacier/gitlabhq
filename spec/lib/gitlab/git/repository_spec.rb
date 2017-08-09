  include Gitlab::EncodingHelper
  shared_examples 'wrapping gRPC errors' do |gitaly_client_class, gitaly_client_method|
    it 'wraps gRPC not found error' do
      expect_any_instance_of(gitaly_client_class).to receive(gitaly_client_method)
        .and_raise(GRPC::NotFound)
      expect { subject }.to raise_error(Gitlab::Git::Repository::NoRepository)
    end

    it 'wraps gRPC unknown error' do
      expect_any_instance_of(gitaly_client_class).to receive(gitaly_client_method)
        .and_raise(GRPC::Unknown)
      expect { subject }.to raise_error(Gitlab::Git::CommandError)
    end
  end

  let(:repository) { Gitlab::Git::Repository.new('default', TEST_REPO_PATH) }
  describe '#root_ref' do
    context 'with gitaly disabled' do
      before do
        allow(Gitlab::GitalyClient).to receive(:feature_enabled?).and_return(false)
      end

      it 'calls #discover_default_branch' do
        expect(repository).to receive(:discover_default_branch)
        repository.root_ref
      end
    end

    it 'returns UTF-8' do
      expect(repository.root_ref).to be_utf8
    end

    it 'gets the branch name from GitalyClient' do
      expect_any_instance_of(Gitlab::GitalyClient::RefService).to receive(:default_branch_name)
      repository.root_ref
    end

    it_behaves_like 'wrapping gRPC errors', Gitlab::GitalyClient::RefService, :default_branch_name do
      subject { repository.root_ref }
    end
  end

  describe "#rugged" do
    describe 'when storage is broken', broken_storage: true  do
      it 'raises a storage exception when storage is not available' do
        broken_repo = described_class.new('broken', 'a/path.git')

        expect { broken_repo.rugged }.to raise_error(Gitlab::Git::Storage::Inaccessible)
      end
    end

    it 'raises a no repository exception when there is no repo' do
      broken_repo = described_class.new('default', 'a/path.git')

      expect { broken_repo.rugged }.to raise_error(Gitlab::Git::Repository::NoRepository)
    end

    context 'with no Git env stored' do
      before do
        expect(Gitlab::Git::Env).to receive(:all).and_return({})
      end

      it "whitelist some variables and pass them via the alternates keyword argument" do
        expect(Rugged::Repository).to receive(:new).with(repository.path, alternates: [])

        repository.rugged
      end
    end

    context 'with some Git env stored' do
      before do
        expect(Gitlab::Git::Env).to receive(:all).and_return({
          'GIT_OBJECT_DIRECTORY' => 'foo',
          'GIT_ALTERNATE_OBJECT_DIRECTORIES' => 'bar',
          'GIT_OTHER' => 'another_env'
        })
      end

      it "whitelist some variables and pass them via the alternates keyword argument" do
        expect(Rugged::Repository).to receive(:new).with(repository.path, alternates: %w[foo bar])

        repository.rugged
      end
    end
  end

  describe '#branch_names' do

    it 'returns UTF-8' do
      expect(subject.first).to be_utf8
    end


    it 'gets the branch names from GitalyClient' do
      expect_any_instance_of(Gitlab::GitalyClient::RefService).to receive(:branch_names)
      subject
    end

    it_behaves_like 'wrapping gRPC errors', Gitlab::GitalyClient::RefService, :branch_names
  describe '#tag_names' do

    it 'returns UTF-8' do
      expect(subject.first).to be_utf8
    end


    it 'gets the tag names from GitalyClient' do
      expect_any_instance_of(Gitlab::GitalyClient::RefService).to receive(:tag_names)
      subject
    end

    it_behaves_like 'wrapping gRPC errors', Gitlab::GitalyClient::RefService, :tag_names
  describe '#archive_prefix' do
    let(:project_name) { 'project-name'}

    before do
      expect(repository).to receive(:name).once.and_return(project_name)
    end

    it 'returns parameterised string for a ref containing slashes' do
      prefix = repository.archive_prefix('test/branch', 'SHA')

      expect(prefix).to eq("#{project_name}-test-branch-SHA")
    end

    it 'returns correct string for a ref containing dots' do
      prefix = repository.archive_prefix('test.branch', 'SHA')

      expect(prefix).to eq("#{project_name}-test.branch-SHA")
    end
  end

  describe '#archive' do
  describe '#archive_zip' do
  describe '#archive_bz2' do
  describe '#archive_fallback' do
  describe '#size' do
  describe '#has_commits?' do
  describe '#empty?' do
  describe '#bare?' do
  describe '#ref_names' do
  describe '#submodule_url_for' do
    let(:repository) { Gitlab::Git::Repository.new('default', TEST_REPO_PATH) }
    let(:ref) { 'master' }
    def submodule_url(path)
      repository.submodule_url_for(ref, path)
    it { expect(submodule_url('six')).to eq('git://github.com/randx/six.git') }
    it { expect(submodule_url('nested/six')).to eq('git://github.com/randx/six.git') }
    it { expect(submodule_url('deeper/nested/six')).to eq('git://github.com/randx/six.git') }
    it { expect(submodule_url('invalid/path')).to eq(nil) }
    context 'uncommitted submodule dir' do
      let(:ref) { 'fix-existing-submodule-dir' }
      it { expect(submodule_url('submodule-existing-dir')).to eq(nil) }
    end
    context 'tags' do
      let(:ref) { 'v1.2.1' }
      it { expect(submodule_url('six')).to eq('git://github.com/randx/six.git') }
    end

    context 'no submodules at commit' do
      let(:ref) { '6d39438' }

      it { expect(submodule_url('six')).to eq(nil) }
  context '#submodules' do
    let(:repository) { Gitlab::Git::Repository.new('default', TEST_REPO_PATH) }
      let(:submodules) { repository.send(:submodules, 'master') }
            "name" => "six",
        expect(nested['name']).to eq('nested/six')
        expect(nested['name']).to eq('deeper/nested/six')
        submodules = repository.send(:submodules, 'fix-existing-submodule-dir')
        submodules = repository.send(:submodules, 'v1.2.1')
            "name" => "six",

      it 'should not break on invalid syntax' do
        allow(repository).to receive(:blob_content).and_return(<<-GITMODULES.strip_heredoc)
          [submodule "six"]
          path = six
          url = git://github.com/randx/six.git

          [submodule]
          foo = bar
        GITMODULES

        expect(submodules).to have_key('six')
      end
      let(:submodules) { repository.send(:submodules, '6d39438') }
  describe '#commit_count' do
    shared_examples 'simple commit counting' do
      it { expect(repository.commit_count("master")).to eq(25) }
      it { expect(repository.commit_count("feature")).to eq(9) }
    context 'when Gitaly commit_count feature is enabled' do
      it_behaves_like 'simple commit counting'
      it_behaves_like 'wrapping gRPC errors', Gitlab::GitalyClient::CommitService, :commit_count do
        subject { repository.commit_count('master') }
    context 'when Gitaly commit_count feature is disabled', skip_gitaly_mock: true  do
      it_behaves_like 'simple commit counting'
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo.remote_add("new_remote", SeedHelper::GITLAB_GIT_TEST_REPO_URL)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
    before(:context) do
      repo = Gitlab::Git::Repository.new('default', TEST_REPO_PATH).rugged
      commit_with_old_name = Gitlab::Git::Commit.decorate(new_commit_edit_old_file(repo))
      rename_commit = Gitlab::Git::Commit.decorate(new_commit_move_file(repo))
      commit_with_new_name = Gitlab::Git::Commit.decorate(new_commit_edit_new_file(repo))
    end

    after(:context) do
      # Erase our commits so other tests get the original repo
      repo = Gitlab::Git::Repository.new('default', TEST_REPO_PATH).rugged
      repo.references.update("refs/heads/master", SeedRepo::LastCommit::ID)
      let(:options) { { ref: "master", follow: true } }
        it "does not follow renames" do
          log_commits = repository.log(options.merge(path: "encoding"))
          aggregate_failures do
            expect(log_commits).to include(commit_with_new_name)
            expect(log_commits).to include(rename_commit)
            expect(log_commits).not_to include(commit_with_old_name)
          end
        context 'without offset' do
          it "follows renames" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG"))

            aggregate_failures do
              expect(log_commits).to include(commit_with_new_name)
              expect(log_commits).to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        context 'with offset=1' do
          it "follows renames and skip the latest commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 1))

            aggregate_failures do
              expect(log_commits).not_to include(commit_with_new_name)
              expect(log_commits).to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        end

        context 'with offset=1', 'and limit=1' do
          it "follows renames, skip the latest commit and return only one commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 1, limit: 1))

            expect(log_commits).to contain_exactly(rename_commit)
          end
        end

        context 'with offset=1', 'and limit=2' do
          it "follows renames, skip the latest commit and return only two commits" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 1, limit: 2))

            aggregate_failures do
              expect(log_commits).to contain_exactly(rename_commit, commit_with_old_name)
            end
          end
        end

        context 'with offset=2' do
          it "follows renames and skip the latest commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 2))

            aggregate_failures do
              expect(log_commits).not_to include(commit_with_new_name)
              expect(log_commits).not_to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        end

        context 'with offset=2', 'and limit=1' do
          it "follows renames, skip the two latest commit and return only one commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 2, limit: 1))

            expect(log_commits).to contain_exactly(commit_with_old_name)
          end
        end

        context 'with offset=2', 'and limit=2' do
          it "follows renames, skip the two latest commit and return only one commit" do
            log_commits = repository.log(options.merge(path: "encoding/CHANGELOG", offset: 2, limit: 2))

            aggregate_failures do
              expect(log_commits).not_to include(commit_with_new_name)
              expect(log_commits).not_to include(rename_commit)
              expect(log_commits).to include(commit_with_old_name)
            end
          end
        it "does not follow renames" do
          log_commits = repository.log(options.merge(path: "CHANGELOG"))
          aggregate_failures do
            expect(log_commits).not_to include(commit_with_new_name)
            expect(log_commits).to include(rename_commit)
            expect(log_commits).to include(commit_with_old_name)
          end
        it "returns an empty array" do
          log_commits = repository.log(options.merge(ref: 'unknown'))
      let(:commits_by_walk) { repository.log(options).map(&:id) }
      let(:commits_by_shell) { repository.log(options.merge({ disable_walk: true })).map(&:id) }
        expect(commits).to satisfy do |commits|
          commits.all? { |commit| commit.committed_date >= options[:after] }
        expect(commits).to satisfy do |commits|
          commits.all? { |commit| commit.committed_date <= options[:before] }
    context 'when multiple paths are provided' do
      let(:options) { { ref: 'master', path: ['PROCESS.md', 'README.md'] } }

      def commit_files(commit)
        commit.diff_from_parent.deltas.flat_map do |delta|
          [delta.old_file[:path], delta.new_file[:path]].uniq.compact
        end
      end

      it 'only returns commits matching at least one path' do
        commits = repository.log(options)

        expect(commits.size).to be > 0
        expect(commits).to satisfy do |commits|
          commits.none? { |commit| (commit_files(commit) & options[:path]).empty? }
        end
      end
  describe "#rugged_commits_between" do
        expect(repository.rugged_commits_between(first_sha, second_sha).count).to eq(3)
        expect(repository.rugged_commits_between(sha, branch).count).to eq(5)
        expect(repository.rugged_commits_between(branch, sha).count).to eq(0) # sha is before branch
        expect(repository.rugged_commits_between(first_branch, second_branch).count).to eq(17)
  describe '#count_commits' do
    shared_examples 'extended commit counting' do
      context 'with after timestamp' do
        it 'returns the number of commits after timestamp' do
          options = { ref: 'master', limit: nil, after: Time.iso8601('2013-03-03T20:15:01+00:00') }

          expect(repository.count_commits(options)).to eq(25)
        end
      end

      context 'with before timestamp' do
        it 'returns the number of commits before timestamp' do
          options = { ref: 'feature', limit: nil, before: Time.iso8601('2015-03-03T20:15:01+00:00') }

          expect(repository.count_commits(options)).to eq(9)
        end
      end

      context 'with path' do
        it 'returns the number of commits with path ' do
          options = { ref: 'master', limit: nil, path: "encoding" }

          expect(repository.count_commits(options)).to eq(2)
        end
      end
    end

    context 'when Gitaly count_commits feature is enabled' do
      it_behaves_like 'extended commit counting'
    end

    context 'when Gitaly count_commits feature is disabled', skip_gitaly_mock: true do
      it_behaves_like 'extended commit counting'
    end
  end

      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new('default', TEST_MUTABLE_REPO_PATH)
      File.open(File.join(SEED_STORAGE_PATH, TEST_MUTABLE_REPO_PATH, '.git', 'config')) do |config_file|
  describe '#ref_name_for_sha' do
    let(:ref_path) { 'refs/heads' }
    let(:sha) { repository.find_branch('master').dereferenced_target.id }
    let(:ref_name) { 'refs/heads/master' }
    it 'returns the ref name for the given sha' do
      expect(repository.ref_name_for_sha(ref_path, sha)).to eq(ref_name)
    it "returns an empty name if the ref doesn't exist" do
      expect(repository.ref_name_for_sha(ref_path, "000000")).to eq("")
    end
    it "raise an exception if the ref is empty" do
      expect { repository.ref_name_for_sha(ref_path, "") }.to raise_error(ArgumentError)
    it "raise an exception if the ref is nil" do
      expect { repository.ref_name_for_sha(ref_path, nil) }.to raise_error(ArgumentError)
  describe '#branches' do
    subject { repository.branches }
    context 'with local and remote branches' do
      let(:repository) do
        Gitlab::Git::Repository.new('default', File.join(TEST_MUTABLE_REPO_PATH, '.git'))
      end
      before do
        create_remote_branch(repository, 'joe', 'remote_branch', 'master')
        repository.create_branch('local_branch', 'master')
      end
      after do
        FileUtils.rm_rf(TEST_MUTABLE_REPO_PATH)
        ensure_seeds
      end
      it 'returns the local and remote branches' do
        expect(subject.any? { |b| b.name == 'joe/remote_branch' }).to eq(true)
        expect(subject.any? { |b| b.name == 'local_branch' }).to eq(true)
      end
    # With Gitaly enabled, Gitaly just doesn't return deleted branches.
    context 'with deleted branch with Gitaly disabled' do
      before do
        allow(Gitlab::GitalyClient).to receive(:feature_enabled?).and_return(false)
      end
      it 'returns no results' do
        ref = double()
        allow(ref).to receive(:name) { 'bad-branch' }
        allow(ref).to receive(:target) { raise Rugged::ReferenceError }
        branches = double()
        allow(branches).to receive(:each) { [ref].each }
        allow(repository.rugged).to receive(:branches) { branches }
        expect(subject).to be_empty
      end
    it_behaves_like 'wrapping gRPC errors', Gitlab::GitalyClient::RefService, :branches
  end
  describe '#branch_count' do
    it 'returns the number of branches' do
      expect(repository.branch_count).to eq(9)
    let(:attributes_path) { File.join(SEED_STORAGE_PATH, TEST_REPO_PATH, 'info/attributes') }
      @repo = Gitlab::Git::Repository.new('default', File.join(TEST_MUTABLE_REPO_PATH, '.git'))
      create_remote_branch(@repo, 'joe', 'remote_branch', 'master')

    it 'returns a Branch with UTF-8 fields' do
      branches = @repo.local_branches.to_a
      expect(branches.size).to be > 0
      branches.each do |branch|
        expect(branch.name).to be_utf8
        expect(branch.target).to be_utf8 unless branch.target.nil?
      end
    end

    it 'gets the branches from GitalyClient' do
      expect_any_instance_of(Gitlab::GitalyClient::RefService).to receive(:local_branches)
        .and_return([])
      @repo.local_branches
    end

    it_behaves_like 'wrapping gRPC errors', Gitlab::GitalyClient::RefService, :local_branches do
      subject { @repo.local_branches }
    end
  end

  describe '#languages' do
    shared_examples 'languages' do
      it 'returns exactly the expected results' do
        languages = repository.languages('4b4918a572fa86f9771e5ba40fbd48e1eb03e2c6')
        expected_languages = [
          { value: 66.63, label: "Ruby", color: "#701516", highlight: "#701516" },
          { value: 22.96, label: "JavaScript", color: "#f1e05a", highlight: "#f1e05a" },
          { value: 7.9, label: "HTML", color: "#e44b23", highlight: "#e44b23" },
          { value: 2.51, label: "CoffeeScript", color: "#244776", highlight: "#244776" }
        ]

        expect(languages.size).to eq(expected_languages.size)

        expected_languages.size.times do |i|
          a = expected_languages[i]
          b = languages[i]

          expect(a.keys.sort).to eq(b.keys.sort)
          expect(a[:value]).to be_within(0.1).of(b[:value])

          non_float_keys = a.keys - [:value]
          expect(a.values_at(*non_float_keys)).to eq(b.values_at(*non_float_keys))
        end
      end

      it "uses the repository's HEAD when no ref is passed" do
        lang = repository.languages.first

        expect(lang[:label]).to eq('Ruby')
      end
    end

    it_behaves_like 'languages'

    context 'with rugged', skip_gitaly_mock: true do
      it_behaves_like 'languages'
    end
  def create_remote_branch(repository, remote_name, branch_name, source_branch_name)
    source_branch = repository.branches.find { |branch| branch.name == source_branch_name }
    rugged = repository.rugged