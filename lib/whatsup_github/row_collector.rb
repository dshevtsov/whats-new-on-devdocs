require_relative 'row'
require_relative 'pulls'
require_relative 'config-reader'

module WhatsupGithub
  # Creates Row objects for the future table
  class RowCollector
    attr_reader :repos, :since

    def initialize(args = {})
      @repos = config.repos
      @since = args[:since]
    end

    def collect_rows
      rows = []
      repos.each do |repo|
        rows << collect_rows_for_a(repo)
      end
      rows.flatten
    end

    def collect_rows_for_a(repo)
      pulls(repo).map do |pull|
        Row.new(
          repo: repo,
          pr_number: pull.number,
          pr_title: pull.title,
          pr_body: pull.body,
          date: pull.closed_at,
          pr_labels: label_names(pull.labels),
          assignee: assignee(pull.assignee),
          author: pull.user.login,
          author_url: pull.user.html_url,
          pr_url: pull.html_url
        )
      end
    end

    def sort_by_date
      collect_rows.sort_by do |c|
        Date.parse(c.date)
      end.reverse
    end

    def reverse(collection)
      collection.reverse
    end

    private

    def assignee(assignee)
      if assignee.nil?
        'NOBODY'
      else
        assignee.login
      end
    end

    def label_names(labels)
      labels.map(&:name)
    end

    def pulls(repo)
      Pulls.new(repo: repo, since: since).filtered
    end

    def config
      Config.instance
    end
  end
end
