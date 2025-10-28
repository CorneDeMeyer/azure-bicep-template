using bicep.demo.Models;

namespace bicep.demo.DomainLogic.Interface
{
    public interface IWeatherService
    {
        Task<IEnumerable<WeatherForecast>> Get();
    }
}
