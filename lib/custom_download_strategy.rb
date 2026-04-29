require "download_strategy"
require "json"

class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    pattern = %r{https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    raise CurlDownloadStrategyError, "Invalid GitHub release URL." unless @url =~ pattern
    _, @owner, @repo, @tag, @filename = *@url.match(pattern)
  end

  def _fetch(url:, resolved_url:, timeout:)
    curl_download "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}",
                  "--header", "Accept: application/octet-stream",
                  "--header", "Authorization: token #{@github_token}",
                  to: temporary_path
  end

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    raise CurlDownloadStrategyError, "HOMEBREW_GITHUB_API_TOKEN is required." unless @github_token
  end

  def asset_id
    @asset_id ||= begin
      meta_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
      result = curl_output("--header", "Authorization: token #{@github_token}",
                           "--header", "Accept: application/vnd.github+json",
                           meta_url)
      assets = JSON.parse(result.stdout).fetch("assets", [])
      match = assets.find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError, "Asset not found: #{@filename}" unless match
      match.fetch("id")
    end
  end
end
