import 'dart:io';

class GitService {
  final String projectPath;

  GitService(this.projectPath);

  Future<bool> isGitRepository() async {
    final dir = Directory('$projectPath/.git');
    return await dir.exists();
  }

  Future<ProcessResult> commitChanges(String message) async {
    // Stage all changes
    await Process.run('git', ['add', '.'], workingDirectory: projectPath);
    // Commit
    return await Process.run('git', ['commit', '-m', message], workingDirectory: projectPath);
  }

  Future<ProcessResult> pushChanges() async {
    return await Process.run('git', ['push'], workingDirectory: projectPath);
  }

  Future<ProcessResult> getStatus() async {
    return await Process.run('git', ['status', '--short'], workingDirectory: projectPath);
  }
}
