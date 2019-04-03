﻿namespace kCura.PDB.Service.Tests.InstallationTests
{
    using kCura.PDB.Service.Installation;
    using kCura.PDB.Service.Services;

    using Moq;

    using NUnit.Framework;

    [TestFixture]
    [Category("Unit")]
    public class UnaffectedInstallationServiceTests
    {
        private UnaffectedInstallationService unaffectedInstallationService;
        private Mock<IApplicationInstallationService> applicationInstallationServiceMock;

        [SetUp]
        public void Setup()
        {
            this.applicationInstallationServiceMock = new Mock<IApplicationInstallationService>();
            this.unaffectedInstallationService = new UnaffectedInstallationService(this.applicationInstallationServiceMock.Object);
        }

        [Test]
        [TestCase(-1)]
        [TestCase(0)]
        [TestCase(14)]
        [TestCase(37715)]
        public void InstallApplication(int activeCaseId)
        {
            // Arrange
            this.applicationInstallationServiceMock.Setup(m => m.InstallApplication()).Verifiable();

            // Act
            this.unaffectedInstallationService.InstallApplication(activeCaseId);

            // Assert
            this.applicationInstallationServiceMock.VerifyAll();
            this.applicationInstallationServiceMock.Verify(m => m.InstallApplication(), Times.Once);
        }
    }
}
