using bicep.demo.DomainLogic.Interface;
using bicep.demo.Models;
using Microsoft.AspNetCore.Mvc;

namespace bicep.demo.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController(
        IWeatherService service,
        ILogger<WeatherForecastController> logger) : ControllerBase
    {
        private readonly IWeatherService weatherService = service;
        private readonly ILogger<WeatherForecastController> _logger = logger;

        [HttpGet]
        public async Task<IEnumerable<WeatherForecast>> Get()
        {
            return await weatherService.Get();
        }
    }
}
