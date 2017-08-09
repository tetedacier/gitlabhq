  let(:repository) { Gitlab::Git::Repository.new(TEST_REPO_PATH) }
  describe :branch_names do
  describe :tag_names do
  describe :archive do
  describe :archive_zip do
  describe :archive_bz2 do
  describe :archive_fallback do
  describe :size do
  describe :has_commits? do
  describe :empty? do
  describe :bare? do
  describe :heads do
  describe :ref_names do
  describe :search_files do
  context :submodules do
    let(:repository) { Gitlab::Git::Repository.new(TEST_REPO_PATH) }
  describe :commit_count do
    change_path = File.join(TEST_NORMAL_REPO_PATH, "CHANGELOG")
    untracked_path = File.join(TEST_NORMAL_REPO_PATH, "UNTRACKED")
    tracked_path = File.join(TEST_NORMAL_REPO_PATH, "files", "ruby", "popen.rb")
        @normal_repo = Gitlab::Git::Repository.new(TEST_NORMAL_REPO_PATH)
        @normal_repo = Gitlab::Git::Repository.new(TEST_NORMAL_REPO_PATH)
          normal_repo = Gitlab::Git::Repository.new(TEST_NORMAL_REPO_PATH)
          @normal_repo = Gitlab::Git::Repository.new(TEST_NORMAL_REPO_PATH)
          File.open(File.join(TEST_NORMAL_REPO_PATH, ".gitignore"), "r") do |f|
          FileUtils.rm_rf(TEST_NORMAL_REPO_PATH)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
      @repo.remote_add("new_remote", SeedHelper::GITLAB_URL)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
    before(:all) do
      repo = Gitlab::Git::Repository.new(TEST_REPO_PATH).rugged
      options = { ref: "master", follow: true }
        let(:log_commits) do
          repository.log(options.merge(path: "encoding"))
        end
        it "should not follow renames" do
          expect(log_commits).to include(commit_with_new_name)
          expect(log_commits).to include(rename_commit)
          expect(log_commits).not_to include(commit_with_old_name)
        let(:log_commits) do
          repository.log(options.merge(path: "encoding/CHANGELOG"))
        it "should follow renames" do
          expect(log_commits).to include(commit_with_new_name)
          expect(log_commits).to include(rename_commit)
          expect(log_commits).to include(commit_with_old_name)
        let(:log_commits) do
          repository.log(options.merge(path: "CHANGELOG"))
        end
        it "should not follow renames" do
          expect(log_commits).to include(commit_with_old_name)
          expect(log_commits).to include(rename_commit)
          expect(log_commits).not_to include(commit_with_new_name)
        let(:log_commits) { repository.log(options.merge(ref: 'unknown')) }
        it "should return empty" do
        satisfy do
          commits.all? { |commit| commit.created_at >= options[:after] }
        satisfy do
          commits.all? { |commit| commit.created_at <= options[:before] }
    after(:all) do
      # Erase our commits so other tests get the original repo
      repo = Gitlab::Git::Repository.new(TEST_REPO_PATH).rugged
      repo.references.update("refs/heads/master", SeedRepo::LastCommit::ID)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)
      File.open(File.join(TEST_MUTABLE_REPO_PATH, '.git', 'config')) do |config_file|
  describe '#mkdir' do
    let(:commit_options) do
      {
        author: {
          email: 'user@example.com',
          name: 'Test User',
          time: Time.now
        },
        committer: {
          email: 'user@example.com',
          name: 'Test User',
          time: Time.now
        },
        commit: {
          message: 'Test message',
          branch: 'refs/heads/fix',
        }
      }
    end

    def generate_diff_for_path(path)
      "diff --git a/#{path}/.gitkeep b/#{path}/.gitkeep
new file mode 100644
index 0000000..e69de29
--- /dev/null
+++ b/#{path}/.gitkeep\n"
    end

    shared_examples 'mkdir diff check' do |path, expected_path|
      it 'creates a directory' do
        result = repository.mkdir(path, commit_options)
        expect(result).not_to eq(nil)

        # Verify another mkdir doesn't create a directory that already exists
        expect{ repository.mkdir(path, commit_options) }.to raise_error('Directory already exists')
      end
    end

    describe 'creates a directory in root directory' do
      it_should_behave_like 'mkdir diff check', 'new_dir', 'new_dir'
    end

    describe 'creates a directory in subdirectory' do
      it_should_behave_like 'mkdir diff check', 'files/ruby/test', 'files/ruby/test'
    end

    describe 'creates a directory in subdirectory with a slash' do
      it_should_behave_like 'mkdir diff check', '/files/ruby/test2', 'files/ruby/test2'
    end

    describe 'creates a directory in subdirectory with multiple slashes' do
      it_should_behave_like 'mkdir diff check', '//files/ruby/test3', 'files/ruby/test3'
    end

    describe 'handles relative paths' do
      it_should_behave_like 'mkdir diff check', 'files/ruby/../test_relative', 'files/test_relative'
    end

    describe 'creates nested directories' do
      it_should_behave_like 'mkdir diff check', 'files/missing/test', 'files/missing/test'
    end

    it 'does not attempt to create a directory with invalid relative path' do
      expect{ repository.mkdir('../files/missing/test', commit_options) }.to raise_error('Invalid path')
    end

    it 'does not attempt to overwrite a file' do
      expect{ repository.mkdir('README.md', commit_options) }.to raise_error('Directory already exists as a file')
    end

    it 'does not attempt to overwrite a directory' do
      expect{ repository.mkdir('files', commit_options) }.to raise_error('Directory already exists')
    end
  end

    let(:attributes_path) { File.join(TEST_REPO_PATH, 'info/attributes') }
    info_dir_path = attributes_path = File.join(TEST_REPO_PATH, 'info')
      @repo = Gitlab::Git::Repository.new(TEST_MUTABLE_REPO_PATH)