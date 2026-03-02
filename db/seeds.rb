Card.destroy_all
BoardColumn.destroy_all
Board.destroy_all

board = Board.create!(name: "Cloudflare Rails Demo")

backlog = board.board_columns.create!(name: "Backlog", color: "#6B7280", position: 1)
in_progress = board.board_columns.create!(name: "In Progress", color: "#3B82F6", position: 2)
review = board.board_columns.create!(name: "Review", color: "#8B5CF6", position: 3)
done = board.board_columns.create!(name: "Done", color: "#10B981", position: 4)

# Backlog cards
backlog.cards.create!(title: "Implement user authentication", description: "Add sign up, login, and session management with secure password hashing", label: "feature", position: 1)
backlog.cards.create!(title: "Fix WebSocket reconnection bug", description: "WebSocket drops after idle timeout and fails to reconnect automatically", label: "bug", position: 2)
backlog.cards.create!(title: "Design onboarding flow", description: "Create wireframes for the new user onboarding experience with step-by-step guidance", label: "design", position: 3)
backlog.cards.create!(title: "Write API documentation", description: "Document all REST endpoints with request/response examples using OpenAPI spec", label: "docs", position: 4)
backlog.cards.create!(title: "Set up CI/CD pipeline", description: "Configure GitHub Actions for automated testing, linting, and deployment to staging", label: "devops", position: 5)

# In Progress cards
in_progress.cards.create!(title: "Build real-time notifications", description: "Implement ActionCable-powered live notifications for card updates and mentions", label: "feature", position: 1)
in_progress.cards.create!(title: "Fix memory leak in worker process", description: "Background job worker memory grows unbounded after processing large batch imports", label: "bug", position: 2)
in_progress.cards.create!(title: "Configure container auto-scaling", description: "Set up horizontal pod autoscaling based on CPU and memory metrics", label: "devops", position: 3)

# Review cards
review.cards.create!(title: "Add search and filtering", description: "Full-text search across cards with filters for labels, assignees, and date ranges", label: "feature", position: 1)
review.cards.create!(title: "Design system component library", description: "Create reusable UI components with consistent spacing, typography, and color tokens", label: "design", position: 2)
review.cards.create!(title: "Write deployment runbook", description: "Step-by-step guide for production deployments including rollback procedures", label: "docs", position: 3)

# Done cards
done.cards.create!(title: "Set up Rails 8 project", description: "Initialize project with Hotwire, ViewComponent, and Tailwind CSS", label: "feature", position: 1)
done.cards.create!(title: "Fix N+1 query on board load", description: "Added eager loading for board columns and cards to eliminate N+1 queries", label: "bug", position: 2)
done.cards.create!(title: "Configure Docker build", description: "Multi-stage Dockerfile optimized for production with minimal image size", label: "devops", position: 3)
done.cards.create!(title: "Create board layout mockups", description: "High-fidelity mockups for the Kanban board with drag-and-drop interactions", label: "design", position: 4)

puts "Seeded: #{Board.count} board, #{BoardColumn.count} columns, #{Card.count} cards"
