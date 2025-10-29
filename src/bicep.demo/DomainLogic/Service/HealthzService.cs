using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace bicep.demo.DomainLogic.Service
{
    public class HealthzService : IHealthCheck
    {
        public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
        {
            return Task.FromResult(
                new HealthCheckResult(HealthStatus.Healthy, "healthy"));
        }
    }
}