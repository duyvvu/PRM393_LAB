import '../models/movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'The Dark Knight',
    posterUrl: 'https://picsum.photos/seed/darkknight/600/900',
    overview: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    genres: ['Action', 'Crime', 'Drama'],
    rating: 9.0,
    releaseYear: 2008,
    isFavorite: false,
    trailers: [
      const Trailer(id: 't1', title: 'Official Trailer 1', thumbnailUrl: 'https://picsum.photos/seed/trailer1/300/200'),
      const Trailer(id: 't2', title: 'Theatrical Trailer', thumbnailUrl: 'https://picsum.photos/seed/trailer2/300/200'),
    ],
  ),
  Movie(
    id: '2',
    title: 'Inception',
    posterUrl: 'https://picsum.photos/seed/inception/600/900',
    overview: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    rating: 8.8,
    releaseYear: 2010,
    isFavorite: true,
    trailers: [
      const Trailer(id: 't3', title: 'Teaser Trailer', thumbnailUrl: 'https://picsum.photos/seed/trailer3/300/200'),
      const Trailer(id: 't4', title: 'Official Trailer', thumbnailUrl: 'https://picsum.photos/seed/trailer4/300/200'),
    ],
  ),
  Movie(
    id: '3',
    title: 'Interstellar',
    posterUrl: 'https://picsum.photos/seed/interstellar/600/900',
    overview: 'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    rating: 8.6,
    releaseYear: 2014,
    isFavorite: false,
    trailers: [
      const Trailer(id: 't5', title: 'Launch Trailer', thumbnailUrl: 'https://picsum.photos/seed/trailer5/300/200'),
      const Trailer(id: 't6', title: 'IMAX Special Trailer', thumbnailUrl: 'https://picsum.photos/seed/trailer6/300/200'),
    ],
  ),
  Movie(
    id: '4',
    title: 'Spider-Man: Into the Spider-Verse',
    posterUrl: 'https://picsum.photos/seed/spiderverse/600/900',
    overview: 'Teenager Miles Morales becomes the Spider-Man of his universe, and must join with five similar counterparts from different dimensions to stop a threat for all realities.',
    genres: ['Animation', 'Action', 'Adventure'],
    rating: 8.4,
    releaseYear: 2018,
    isFavorite: false,
    trailers: [
      const Trailer(id: 't7', title: 'Official Trailer', thumbnailUrl: 'https://picsum.photos/seed/trailer7/300/200'),
    ],
  ),
];
