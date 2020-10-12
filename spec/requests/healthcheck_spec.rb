RSpec.describe "/healthcheck", type: :request do
  def data(body = response.body)
    JSON.parse(body).deep_symbolize_keys
  end

  it "should respond with 'OK'" do
    get "/healthcheck"

    expect(response.status).to eq(200)
    expect(data.fetch(:status)).to eq("ok")
  end

  it "includes useful information about each check" do
    get "/healthcheck"

    expect(data.fetch(:checks)).to include(
      redis_connectivity: { status: "ok" },
      database_connectivity: { status: "ok" },
    )
  end
end
