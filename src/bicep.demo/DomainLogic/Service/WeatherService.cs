using bicep.demo.DomainLogic.Interface;
using bicep.demo.Models;

namespace bicep.demo.DomainLogic.Service
{
    public class WeatherService : IWeatherService
    {
        public Task<IEnumerable<WeatherForecast>> Get()
        {
            var result = Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Constants.Summaries[Random.Shared.Next(Constants.Summaries.Length)]
            })
            .ToArray();

            if (result.Any())
            {
                return Task.FromResult(result.AsEnumerable());
            }

            throw new Exception("No weather data available");
        }
    }
}
