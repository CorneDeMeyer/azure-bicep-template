using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Mvc.Testing;
using bicep.demo.DomainLogic.Interface;
using bicep.demo.DomainLogic.Service;
using System.Net.Http.Json;
using bicep.demo.Models;

namespace bicep.demo.itests
{
    public class WeatherServiceTests
    {
        private string environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Local";
        private const string EnvironmentUrlVariable = "CONTAINER_NAME";
        private readonly HttpClient? _httpClient;
        private string _url;

        public WeatherServiceTests()
        {
            _url = GetWeatherUrl();
            
            if (environment.Equals("local", StringComparison.OrdinalIgnoreCase))
            {
                var application = new WebApplicationFactory<Program>()
                    .WithWebHostBuilder(builder =>
                    {
                        builder.ConfigureServices((ctx, services) =>
                        {
                            services.AddTransient<IWeatherService, WeatherService>();
                        });
                    });

                _httpClient = application.CreateClient();
            }
            else
            {
                _httpClient = new HttpClient
                {
                    BaseAddress = new Uri(_url)
                };
            }
        }

        [Fact]
        public async Task WeatherService_Get_Success()
        {
            var httpResult = await _httpClient.GetAsync($"/WeatherForecast");

            Assert.NotNull(httpResult);
            Assert.Equal(System.Net.HttpStatusCode.OK, httpResult.StatusCode);

            var result = await httpResult.Content.ReadFromJsonAsync<IEnumerable<WeatherForecast>>();
            Assert.IsAssignableFrom<IEnumerable<WeatherForecast>>(result);
            Assert.True(result?.Any());
        }

        private string GetWeatherUrl()
        {
            if (environment.Equals("local", StringComparison.OrdinalIgnoreCase))
            {
                return "http://localhost:5054";
            }

            return Environment.GetEnvironmentVariable(EnvironmentUrlVariable) ?? throw new KeyNotFoundException($"Environment Variable: ${EnvironmentUrlVariable} not found.");
        }
    }
}
