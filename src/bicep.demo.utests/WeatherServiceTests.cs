using bicep.demo.DomainLogic.Service;
using bicep.demo.Models;
using Moq;

namespace bicep.demo.utests
{
    public class WeatherServiceTests
    {
        [Fact(DisplayName = "WeatherService Get - Is Successful")]
        public async Task WeatherService_Get_Success()
        {
            var service = new WeatherService();
            var result = await service.Get();

            Assert.NotNull(result);
            Assert.IsAssignableFrom<IEnumerable<WeatherForecast>>(result);
            Assert.True(result.Any());
        }
    }
}
