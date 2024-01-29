## Tài liệu nghiên cứu về Animation tổng hợp
### Các khái niệm cơ bản

**1. KeyframeSequence (Dãy Keyframe):**
   - **Chức năng:** Là một chuỗi các "keyframe" được sắp xếp theo thứ tự thời gian.
   - **Sử dụng:** Dùng để xác định trạng thái quan trọng của đối tượng tại các điểm thời gian cụ thể trong quá trình chuyển động hoặc thay đổi.

**2. Keyframe (Khung Khóa):**
   - **Chức năng:** Là điểm dữ liệu chứa **thông tin về trạng thái** của đối tượng tại một thời điểm cụ thể.
   - **Sử dụng:** Được sử dụng để xác định giá trị của các thuộc tính như vị trí, quay, kích thước, màu sắc tại các thời điểm khác nhau.

**3. Tween (Tạo bước trung gian):**
   - **Chức năng:** Là kỹ thuật tạo các khung giữa tự động giữa hai keyframe để tạo ra chuyển động mượt mà và tự nhiên.
   - **Sử dụng:** Giúp tạo ra các bước trung gian, hoặc "in-between frames", giữa các trạng thái cụ thể của đối tượng, làm cho chuyển động trở nên nhẹ nhàng và không bị gián đoạn.

Tổng cộng, KeyframeSequence quản lý sự sắp xếp thời gian của các Keyframe, trong khi Keyframe xác định trạng thái tại một thời điểm cụ thể. Tweening là quá trình tạo ra các bước trung gian giữa các keyframe để tạo ra chuyển động mượt mà trong đồ họa và hoạt hình.

### Phân loại
1. Theo thông tin

- **Phạm vị Tween**

- Loại số: loại này có thể Tween, tính toán render, nội suy tuyến tính
- Loại có thể nội suy, VD: CFrame, Color. Tương tự như số nhưng đã có phương thức nội suy sẵn.
- Loại boolean: có thể coi là một phiên bản đơn giản hơn của số
- Loại function: thông tin được tính toán theo cách riêng của nó.

- ***Số và Nội suy có thể dùng TweenService được***

2. Thông tin Tween - chuyển tiếp 2 Keyframe

- **Phạm vi Keyframe đơn**

- *Trạng thái/Tư thế: tập thông tin tương ứng tại thời điểm Keyframe đó!*

- Loại cố định: được cố định khi khởi tạo, tuy nhiên vẫn có thể sửa đổi
- Loại function: thông tin được tính toán theo
   - *Thời điểm Bắt đầu*: khi Keyframe là điểm bắt đầu Tween
   - *Thời điểm Kết thúc*: khi Keyframe là điểm kết thúc Tween
   - *Thời gian thực*: khi thông tin phụ thuộc vào hàm thời gian hoặc tương tự

- **Phạm vi 2 Keyframe**

- Điểm đầu: điểm đầu Tween
- Điểm cuối: điểm cuối Tween
- *Các điểm giữa*: tập hợp điểm giữa Tween, được dùng trong tính toán nội suy đường cong - Bezier Curves
- ***Biến thể function: tính thông tin tương tự với Phạm vi Keyframe***

3. Sự nới lỏng - Tween Style

- *Tất cả phong cách đều có thể quy về hàm(alpha) theo thời gian hoặc tương tự*

VD: sin: sin(x * pi / 2), sin In: 1 - cos(x * pi / 2)

## Phân tích thiết kế

### Cấu trúc

- Cấu trúc phức tạp dần từ Tween: cấu từ 2 Keyframe, 1 Transition
- Phức tạp dần: Tween -> KeyframeSequence, CompositeKeyframeSequence, CompositeAnimation. Bản chất tương tự nhau, tương tự AnimationTrack
- *Riêng Tween: là đối tượng không tạo thêm luồng khi phát*

### Tốc độ

- Thành phần con lấy tốc độ bằng **chuỗi tích** *thành phần cha trở lên*!
- Được đặt lại về ban đầu khi *chạm kết* hoặc **hủy**

### Lặp lại - loop

- Quy ước mặc định 0
- *Quy ước -1 là lặp vô hạn*, còn lại lặp số Loop lần

### Nghịch đảo - reverse

- Khi được xác định - true, Tween sẽ cố gắng đưa ngược thông tin trở lại trạng thái ban đầu và gấp đôi độ dài của nó

### Đặt thông tin thuộc tính - set prop

- Cung cấp khả năng tính toán chuẩn cho các dạng số, bool, color, vv
- Và loại Bù như Postion, CFrame
- Sự tùy chỉnh tạo ra hành vi cực kì khó đoán, nhưng cũng mang tính mở cao

## Thiết kế

### Keyframe
- Thành phần nhỏ nhất, chứa thông tin về 1 thuộc tính tại thời điểm xác định
1. Properties

- ***float* TimePosition**: điểm thời gian của Keyframe
- ***string* Prop**: tên thuộc tính
- ***any* Value**: giá trị thuộc tính
3. Events
- **Reached?**: Kích hoạt khi chạm đến Keyframe

### Transition
- Thành phần chứa thông tin nới lỏng, chuyển tiếp giữa 2 Keyframe

1. Properties

- ***float* TimeStart**: bắt đầu của hàm thời gian
- ***float* TimeEnd**: kết thúc của hàm thời gian
- ***function* TimeFunction**: hàm thời gian

### Tween
- Thành phần nới lỏng, biến đổi thông tin của 2 Keyframe

1. Properties

- ***Keyframe* StartKeyframe**: Keyframe bắt đầu
- ***Keyframe* EndKeyframe**: Keyframe kết thúc
- ***any* Start**: thông tin bắt đầu
- ***any* End**: thông tin kết thúc
- ***table* Middles**: chuỗi điểm thông tin giữa
- ***Transition* Transition**: thành phần biến đổi, nới lỏng

### KeyframeSequence
- Đối tượng được cấu thành từ nhiều Keyframe, tương ứng với 1 đối tượng và 1 hay nhiều thuộc tính
1. Properties

- ***Instance* Object**: Đối tượng được Animation
- ***Keyframe table* Keyframes**: Chuỗi Keyframes
- ***Transition table* Transitions**: Chuỗi biến đổi, luôn nhỏ hơn Keyframes 1

### CompositeKeyframeSequence
- Tổng hợp từ nhiều KeyframeSequence, tạo thành cấu trúc Animation phức tạp
ứng với 1 object và 1 hay nhiều thông tin
1.Properties

### CompositeAnimation
- Đối tượng Hoạt ảnh cuối cùng!
- Tổng hợp lại từ 1 hay nhiều object và 1 hay nhiều thông tin.
- Là dạng phức hợp cao.