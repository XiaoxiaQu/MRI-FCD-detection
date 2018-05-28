#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkLabelStatisticsImageFilter.h"
#include "itkImageRegionConstIterator.h"
#include "itkImageRegionIterator.h"

//#include <iostream>
//#include <iomanip>
//#include <fstream>
//using namespace std;

//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    if( argc < 3 )
      {
      std::cerr << "Missing Parameters " << std::endl;
      std::cerr << "Usage: " << argv[0];
      std::cerr << " InputImage[1] OutImage[2]" << std::endl;
      return EXIT_FAILURE;
      }

  const unsigned int Dimension = 3;
  typedef double PixelType;
  typedef itk::Image<PixelType, Dimension >  ImageType;
  typedef itk::Image<unsigned int, Dimension >   LabelImageType;

  typedef itk::ImageFileReader< ImageType>     ReaderType;
  typedef itk::ImageFileWriter< ImageType >    WriterType;

  ReaderType::Pointer reader = ReaderType::New();
  reader->SetFileName( argv[1] );
  WriterType::Pointer writer = WriterType::New();
  writer->SetFileName( argv[2] );

  // Update
    try
      {
      reader->Update();
      }
    catch (itk::ExceptionObject &e)
      {
      std::cerr << "exception in file reader " << std::endl;
      std::cout << e << std::endl;
      return EXIT_FAILURE;
      }
//-------------------------------------------------------------------------
// generate an image with labels
  typedef itk::ImageRegionConstIterator< ImageType > ConstIteratorType;
  typedef itk::ImageRegionIterator< LabelImageType>       IteratorType;

  ImageType::Pointer image = reader->GetOutput();
  LabelImageType::Pointer LabelImage = LabelImageType::New();
  const ImageType::RegionType   region=image->GetBufferedRegion();

  LabelImage->SetRegions( reader->GetOutput()->GetLargestPossibleRegion());
  LabelImage->SetSpacing( reader->GetOutput()->GetSpacing() );
  LabelImage->SetOrigin( reader->GetOutput()->GetOrigin());
  LabelImage->SetDirection(reader->GetOutput()->GetDirection());
  LabelImage->Allocate();

  ConstIteratorType inputIt(image, region);
  IteratorType      LabelIt(LabelImage, region);

  inputIt.GoToBegin();
  LabelIt.GoToBegin();

  while( !inputIt.IsAtEnd() )
    {
     if (inputIt.Get()>0.01)
     {
      LabelIt.Set(255);
     }
      else
     {
      LabelIt.Set(0);
     }
    ++inputIt;
    ++LabelIt;
    }

//---------------------------------------------------------------------------
  typedef itk::LabelStatisticsImageFilter< ImageType, LabelImageType > LabelStatisticsImageFilterType;
  LabelStatisticsImageFilterType::Pointer labelStatisticsImageFilter = LabelStatisticsImageFilterType::New();
  labelStatisticsImageFilter->SetLabelInput(LabelImage);
  labelStatisticsImageFilter->SetInput(image);
  labelStatisticsImageFilter->Update();
 
  std::cout << "Number of labels: " << labelStatisticsImageFilter->GetNumberOfLabels() << std::endl;
  std::cout << std::endl;
 
  typedef LabelStatisticsImageFilterType::ValidLabelValuesContainerType ValidLabelValuesType;
  typedef LabelStatisticsImageFilterType::LabelPixelType                LabelPixelType;

  PixelType Mean=labelStatisticsImageFilter->GetMean( 255 ) ;
  PixelType Sigma=labelStatisticsImageFilter->GetSigma( 255 ) ;
  //---------------------------------------------------------------
  ImageType::Pointer OutImage = ImageType::New();

  OutImage->SetRegions( reader->GetOutput()->GetLargestPossibleRegion());
  OutImage->SetSpacing( reader->GetOutput()->GetSpacing() );
  OutImage->SetOrigin( reader->GetOutput()->GetOrigin());
  OutImage->SetDirection(reader->GetOutput()->GetDirection());
  OutImage->Allocate();

  // typedef itk::ImageRegionConstIterator< ImageType > ConstIteratorType;
  //typedef itk::ImageRegionIterator< LabelImageType>       IteratorType;
  typedef itk::ImageRegionIterator< ImageType>       IteratorType2;
  IteratorType2      OutIt(OutImage, region);
  inputIt.GoToBegin();
  OutIt.GoToBegin();

  while( !inputIt.IsAtEnd() )
    {

      OutIt.Set((inputIt.Get()-Mean)/Sigma);

    ++inputIt;
    ++OutIt;
    }
  writer->SetInput( OutImage);
      std::cout  << "Writing the image as " << std::endl;
      std::cout  << argv[2] << std::endl;
      try
      {
      writer->Update();
      }
    catch (itk::ExceptionObject & e)
      {
      std::cerr << "exception in file writer " << std::endl;
      std::cerr << e << std::endl;
      return EXIT_FAILURE;
      }



 
  return EXIT_SUCCESS;
}
 

